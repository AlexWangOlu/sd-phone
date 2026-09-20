import { useCallback, useEffect, useRef, useState } from 'react';

import { useNuiEvent } from '@/hooks/useNuiEvent';

import type { LiveHolder, LiveViewer, RecordKind } from './data';
import { mdtLiveDraft, mdtLiveJoin, mdtLiveLeave, mdtLiveLock, mdtLiveUnlock } from './mdtApi';
import { useMdtSession } from './useMdtSession';

const DRAFT_MS = 250;
const HEARTBEAT_MS = 8000;

export type LiveGone = 'closed' | 'revoked' | null;

export interface LiveRecord {
    viewers:    LiveViewer[];
    drafts:     Record<string, unknown>;
    savedAt:    number;
    savedBy:    string | null;
    gone:       LiveGone;
    heldBy:     (field: string) => LiveHolder | null;
    liveValue:  <T>(field: string, fallback: T) => T;
    claim:      (field: string) => Promise<string | null>;
    release:    (field: string) => void;
    releaseAll: () => void;
    send:       (field: string, value: unknown) => void;
}

interface Pending {
    value: unknown;
    timer: number | null;
    last:  number;
}

export function useLiveRecord(kind: RecordKind, ref: string | null): LiveRecord {
    const { me } = useMdtSession();
    const selfId = me?.citizenid ?? '';

    const [viewers, setViewers] = useState<LiveViewer[]>([]);
    const [locks, setLocks] = useState<Record<string, LiveHolder>>({});
    const [drafts, setDrafts] = useState<Record<string, unknown>>({});
    const [savedAt, setSavedAt] = useState(0);
    const [savedBy, setSavedBy] = useState<string | null>(null);
    const [gone, setGone] = useState<LiveGone>(null);

    const held = useRef(new Set<string>());
    const pending = useRef(new Map<string, Pending>());

    useEffect(() => {
        if (!ref) return;
        let active = true;
        setViewers([]);
        setLocks({});
        setDrafts({});
        setGone(null);
        void mdtLiveJoin(kind, ref).then(state => {
            if (!active || !state) return;
            setViewers(state.viewers ?? []);
            setLocks(state.locks ?? {});
            setDrafts(state.drafts ?? {});
        });
        const heldFields = held.current;
        const queue = pending.current;
        return () => {
            active = false;
            for (const entry of queue.values()) if (entry.timer !== null) window.clearTimeout(entry.timer);
            queue.clear();
            heldFields.clear();
            mdtLiveLeave(kind, ref);
        };
    }, [kind, ref]);

    useEffect(() => {
        if (!ref) return;
        const id = window.setInterval(() => {
            for (const field of held.current) void mdtLiveLock(kind, ref, field);
        }, HEARTBEAT_MS);
        return () => window.clearInterval(id);
    }, [kind, ref]);

    useNuiEvent('sd-phone:mdt:live', event => {
        if (!ref || event.type !== kind || event.ref !== ref) return;
        const field = event.field;
        switch (event.kind) {
            case 'presence':
                setViewers(event.viewers ?? []);
                break;
            case 'lock':
                if (!field) break;
                setLocks(prev => {
                    const next = { ...prev };
                    if (event.holder) next[field] = event.holder;
                    else delete next[field];
                    return next;
                });
                setDrafts(prev => {
                    if (!(field in prev)) return prev;
                    const next = { ...prev };
                    delete next[field];
                    return next;
                });
                break;
            case 'draft':
                if (!field) break;
                setDrafts(prev => ({ ...prev, [field]: event.value }));
                break;
            case 'saved': {
                const fields = event.fields ?? [];
                for (const name of fields) held.current.delete(name);
                setLocks(prev => {
                    const next = { ...prev };
                    for (const name of fields) delete next[name];
                    return next;
                });
                setDrafts(prev => {
                    const next = { ...prev };
                    for (const name of fields) delete next[name];
                    return next;
                });
                setSavedBy(event.by ?? null);
                setSavedAt(Date.now());
                break;
            }
            case 'closed':
                setGone('closed');
                break;
            case 'revoked':
                setGone('revoked');
                break;
        }
    });

    const heldBy = useCallback((field: string): LiveHolder | null => {
        const holder = locks[field];
        return holder && holder.citizenid !== selfId ? holder : null;
    }, [locks, selfId]);

    const liveValue = useCallback(<T,>(field: string, fallback: T): T => {
        const holder = locks[field];
        if (!holder || holder.citizenid === selfId || !(field in drafts)) return fallback;
        return drafts[field] as T;
    }, [locks, drafts, selfId]);

    const flush = useCallback((field: string) => {
        const entry = pending.current.get(field);
        if (!entry || !ref) return;
        entry.timer = null;
        entry.last = Date.now();
        if (held.current.has(field)) mdtLiveDraft(kind, ref, field, entry.value);
    }, [kind, ref]);

    const send = useCallback((field: string, value: unknown) => {
        if (!ref) return;
        const entry = pending.current.get(field) ?? { value, timer: null, last: 0 };
        entry.value = value;
        pending.current.set(field, entry);
        if (entry.timer !== null) return;
        const wait = Math.max(0, DRAFT_MS - (Date.now() - entry.last));
        entry.timer = window.setTimeout(() => flush(field), wait);
    }, [ref, flush]);

    const claim = useCallback(async (field: string): Promise<string | null> => {
        if (!ref) return null;
        if (held.current.has(field)) return null;
        held.current.add(field);
        const error = await mdtLiveLock(kind, ref, field);
        if (error) {
            held.current.delete(field);
            return error;
        }
        const entry = pending.current.get(field);
        if (entry && entry.timer === null) flush(field);
        return null;
    }, [kind, ref, flush]);

    const release = useCallback((field: string) => {
        if (!ref || !held.current.has(field)) return;
        held.current.delete(field);
        const entry = pending.current.get(field);
        if (entry?.timer != null) window.clearTimeout(entry.timer);
        pending.current.delete(field);
        mdtLiveUnlock(kind, ref, field);
    }, [kind, ref]);

    const releaseAll = useCallback(() => {
        for (const field of Array.from(held.current)) release(field);
    }, [release]);

    return { viewers, drafts, savedAt, savedBy, gone, heldBy, liveValue, claim, release, releaseAll, send };
}
