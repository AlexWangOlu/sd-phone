import { useEffect, useRef, useState } from 'react';

import { IslandPetArt, SPRITE_H, SPRITE_W, type IslandPetId, type PetMood } from './islandPets';

const LEAVE_MS = 240;
const CHEER_MS = 1800;
const LOW_BATTERY = 20;

export function IslandPet({ id, left, top, height, run, busy, battery, playing, ringing }: {
    id:      IslandPetId;
    left:    number;
    top:     number;
    height:  number;
    run:     number;
    busy:    boolean;
    battery: number;
    playing: boolean;
    ringing: boolean;
}) {
    const [shown, setShown] = useState(!busy);
    const [leaving, setLeaving] = useState(false);
    const [cheering, setCheering] = useState(false);
    const leaveTimer = useRef<ReturnType<typeof setTimeout> | null>(null);
    const cheerTimer = useRef<ReturnType<typeof setTimeout> | null>(null);

    useEffect(() => {
        if (leaveTimer.current) { clearTimeout(leaveTimer.current); leaveTimer.current = null; }
        if (!busy) { setLeaving(false); setShown(true); return; }
        if (!shown) return;
        setLeaving(true);
        leaveTimer.current = setTimeout(() => {
            setShown(false);
            setLeaving(false);
            leaveTimer.current = null;
        }, LEAVE_MS);
    }, [busy, shown]);

    useEffect(() => () => {
        if (leaveTimer.current) clearTimeout(leaveTimer.current);
        if (cheerTimer.current) clearTimeout(cheerTimer.current);
    }, []);

    if (id === 'none' || !shown) return null;

    const mood: PetMood =
        ringing                  ? 'startled'
        : playing                ? 'dancing'
        : cheering               ? 'happy'
        : battery <= LOW_BATTERY ? 'sleepy'
        : 'idle';

    const roaming = mood === 'idle' || mood === 'happy';
    const width = height * (SPRITE_W / SPRITE_H);

    function poke() {
        if (cheerTimer.current) clearTimeout(cheerTimer.current);
        setCheering(true);
        cheerTimer.current = setTimeout(() => { setCheering(false); cheerTimer.current = null; }, CHEER_MS);
    }

    return (
        <button
            type="button"
            onClick={poke}
            aria-hidden
            tabIndex={-1}
            className={`absolute z-[301] cursor-pointer bg-transparent p-0 ${leaving ? 'sd-pet-out' : 'sd-pet-in'}`}
            style={{ left, top, width, height }}
        >
            <span
                className={roaming ? 'sd-pet-walker' : undefined}
                style={{ display: 'block', ['--pet-run' as string]: `${run}px` }}
            >
                <IslandPetArt id={id} mood={mood} height={height} />
            </span>
        </button>
    );
}
