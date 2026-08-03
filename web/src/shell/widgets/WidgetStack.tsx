import { useEffect, useRef, useState } from 'react';
import type { CSSProperties, PointerEvent as ReactPointerEvent, ReactNode, WheelEvent as ReactWheelEvent } from 'react';

import type { WidgetCard } from '@/apps/appstore/appsApi';

const SWIPE_PX = 18;

// One notch per card. A trackpad emits a burst of small deltas for a single flick, so without a
// gate a stack of three would run to the end on one gesture. Matches AppSwitcher's wheel step.
const WHEEL_MS = 280;

const SLIDE_MS = 300;

export function WidgetStack({ cards, active, onActive, height, editing, render }: {
    cards:    WidgetCard[];
    active:   number;
    onActive: (index: number) => void;
    height:   number;
    editing:  boolean;
    render:   (card: WidgetCard, index: number) => ReactNode;
}) {
    const start = useRef<{ y: number; at: number } | null>(null);
    const lastWheel = useRef(0);
    const [drag, setDrag] = useState(0);
    const [leaving, setLeaving] = useState<{ at: number; dir: number } | null>(null);
    const shown = useRef(active);
    const count = cards.length;
    const index = Math.min(Math.max(active, 0), count - 1);

    useEffect(() => { setDrag(0); }, [index]);

    useEffect(() => {
        const from = shown.current;
        shown.current = index;
        if (from === index) return;
        setLeaving({ at: from, dir: index > from ? 1 : -1 });
        const t = window.setTimeout(() => setLeaving(null), SLIDE_MS);
        return () => window.clearTimeout(t);
    }, [index]);

    if (count <= 1) return <>{render(cards[0], 0)}</>;

    function step(delta: number) {
        const next = index + delta;
        if (next < 0 || next >= count) return;
        onActive(next);
    }

    function onWheel(e: ReactWheelEvent) {
        if (editing || e.deltaY === 0) return;
        e.stopPropagation();
        const now = Date.now();
        if (now - lastWheel.current < WHEEL_MS) return;
        lastWheel.current = now;
        step(e.deltaY > 0 ? 1 : -1);
    }

    function onDown(e: ReactPointerEvent) {
        if (editing) return;
        start.current = { y: e.clientY, at: Date.now() };
    }

    function onMove(e: ReactPointerEvent) {
        const s = start.current;
        if (!s) return;
        const dy = e.clientY - s.y;
        const room = (dy < 0 && index === count - 1) || (dy > 0 && index === 0);
        setDrag(room ? dy * 0.25 : dy);
    }

    function onUp() {
        const s = start.current;
        start.current = null;
        if (!s) return;
        if (Math.abs(drag) >= SWIPE_PX) step(drag < 0 ? 1 : -1);
        setDrag(0);
    }

    return (
        <div
            className="relative overflow-hidden"
            style={{ height, touchAction: 'none' }}
            onWheel={onWheel}
            onPointerDown={onDown}
            onPointerMove={onMove}
            onPointerUp={onUp}
            onPointerCancel={onUp}
        >
            <div
                style={{
                    transform: `translateY(${drag}px)`,
                    transition: start.current ? 'none' : 'transform 0.26s cubic-bezier(0.32,0.72,0,1)',
                }}
            >
                {leaving && cards[leaving.at] && (
                    <div
                        aria-hidden
                        className="pointer-events-none absolute inset-0"
                        style={{
                            '--dir': leaving.dir,
                            animation: `widget-card-out ${SLIDE_MS}ms cubic-bezier(0.32,0.72,0,1) both`,
                        } as CSSProperties}
                    >
                        {render(cards[leaving.at], leaving.at)}
                    </div>
                )}
                <div
                    key={index}
                    style={leaving
                        ? ({ '--dir': leaving.dir, animation: `widget-card-in ${SLIDE_MS}ms cubic-bezier(0.32,0.72,0,1) both` } as CSSProperties)
                        : undefined}
                >
                    {render(cards[index], index)}
                </div>
            </div>

            <div className="pointer-events-none absolute right-[5px] top-1/2 flex -translate-y-1/2 flex-col gap-[4px]">
                {cards.map((_, i) => (
                    <span
                        key={i}
                        className="h-[4px] w-[4px] rounded-full bg-white"
                        style={{
                            opacity: i === index ? 0.95 : 0.35,
                            boxShadow: '0 0 2px rgba(0,0,0,0.5)',
                            transition: 'opacity 0.2s ease',
                        }}
                    />
                ))}
            </div>
        </div>
    );
}
