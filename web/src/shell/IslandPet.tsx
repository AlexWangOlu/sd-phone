import { useEffect, useRef, useState } from 'react';

import { IslandPetArt, type IslandPetId, type PetMood } from './islandPets';

const LEAVE_MS = 260;
const CHEER_MS = 2200;
const LOW_BATTERY = 20;

export function IslandPet({ id, x, y, width, height, busy, battery, playing, ringing }: {
    id:       IslandPetId;
    x:        number;
    y:        number;
    width:    number;
    height:   number;
    busy:     boolean;
    battery:  number;
    playing:  boolean;
    ringing:  boolean;
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
        ringing                        ? 'startled'
        : playing                      ? 'dancing'
        : cheering                     ? 'happy'
        : battery <= LOW_BATTERY       ? 'sleepy'
        : 'idle';

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
            className={`absolute z-[201] flex cursor-pointer items-end justify-center bg-transparent ${leaving ? 'sd-pet-out' : 'sd-pet-in'}`}
            style={{ left: x, top: y, width, height }}
        >
            <IslandPetArt id={id} mood={mood} size={width} />
        </button>
    );
}
