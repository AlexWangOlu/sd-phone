import { t } from '@/i18n';

export type IslandPetId = 'none' | 'cat' | 'dog' | 'capybara' | 'duck' | 'penguin' | 'frog';

export type PetMood = 'idle' | 'sleepy' | 'happy' | 'dancing' | 'startled';

export const ISLAND_PETS: readonly IslandPetId[] =
    ['none', 'cat', 'dog', 'capybara', 'duck', 'penguin', 'frog'] as const;

export function islandPetLabel(id: IslandPetId): string {
    switch (id) {
        case 'cat':      return t('shell.petCat', 'Cat');
        case 'dog':      return t('shell.petDog', 'Dog');
        case 'capybara': return t('shell.petCapybara', 'Capybara');
        case 'duck':     return t('shell.petDuck', 'Duck');
        case 'penguin':  return t('shell.petPenguin', 'Penguin');
        case 'frog':     return t('shell.petFrog', 'Frog');
        default:         return t('shell.petNone', 'Off');
    }
}

function Eyes({ closed, tint = '#12121a' }: { closed: boolean; tint?: string }) {
    if (closed) {
        return (
            <>
                <path d="M8.4 11.2q1.5 1.3 3 0" stroke={tint} strokeWidth="1.1" fill="none" strokeLinecap="round" />
                <path d="M16.6 11.2q1.5 1.3 3 0" stroke={tint} strokeWidth="1.1" fill="none" strokeLinecap="round" />
            </>
        );
    }
    return (
        <>
            <ellipse className="sd-pet-blink" cx="9.9" cy="11.3" rx="1.5" ry="1.7" fill={tint} />
            <ellipse className="sd-pet-blink" cx="18.1" cy="11.3" rx="1.5" ry="1.7" fill={tint} />
            <circle cx="10.4" cy="10.7" r="0.5" fill="#fff" />
            <circle cx="18.6" cy="10.7" r="0.5" fill="#fff" />
        </>
    );
}

function Blush() {
    return (
        <>
            <ellipse cx="6.6" cy="14.2" rx="1.7" ry="1.1" fill="#FF8FA8" opacity="0.5" />
            <ellipse cx="21.4" cy="14.2" rx="1.7" ry="1.1" fill="#FF8FA8" opacity="0.5" />
        </>
    );
}

function Cat({ asleep }: { asleep: boolean }) {
    return (
        <g>
            <path d="M6.5 6.5 L8.2 1.6 L12.4 4.6 Z" fill="#9A8478" />
            <path d="M21.5 6.5 L19.8 1.6 L15.6 4.6 Z" fill="#9A8478" />
            <path d="M7.9 5.9 L8.8 3.3 L11 4.9 Z" fill="#F2A6C0" />
            <path d="M20.1 5.9 L19.2 3.3 L17 4.9 Z" fill="#F2A6C0" />
            <ellipse cx="14" cy="11.8" rx="9.2" ry="8.4" fill="#B39C8D" />
            <Eyes closed={asleep} />
            <path d="M12.9 14.6 h2.2 l-1.1 1.2 Z" fill="#F2A6C0" />
            <path d="M4.6 13.4 h3.4 M4.9 15.2 h3.1 M23.4 13.4 h-3.4 M23.1 15.2 h-3.1"
                stroke="#ffffff" strokeOpacity="0.55" strokeWidth="0.7" strokeLinecap="round" />
            <Blush />
        </g>
    );
}

function Dog({ asleep }: { asleep: boolean }) {
    return (
        <g>
            <ellipse cx="4.8" cy="10.4" rx="3.1" ry="5.2" fill="#7A5638" transform="rotate(-14 4.8 10.4)" />
            <ellipse cx="23.2" cy="10.4" rx="3.1" ry="5.2" fill="#7A5638" transform="rotate(14 23.2 10.4)" />
            <ellipse cx="14" cy="11.8" rx="9" ry="8.3" fill="#C79A6B" />
            <ellipse cx="14" cy="15.6" rx="4.6" ry="3.5" fill="#E4C39B" />
            <Eyes closed={asleep} />
            <ellipse cx="14" cy="14.2" rx="1.7" ry="1.3" fill="#2A2A33" />
            <path d="M14 15.4 v1.6" stroke="#2A2A33" strokeWidth="0.8" strokeLinecap="round" />
            <Blush />
        </g>
    );
}

function Capybara({ asleep }: { asleep: boolean }) {
    return (
        <g>
            <ellipse cx="6.6" cy="5.4" rx="2.2" ry="2" fill="#8C6A4A" />
            <ellipse cx="21.4" cy="5.4" rx="2.2" ry="2" fill="#8C6A4A" />
            <rect x="3.6" y="4.6" width="20.8" height="15.4" rx="7.2" fill="#A8815C" />
            <Eyes closed={asleep} />
            <ellipse cx="14" cy="16.1" rx="5.4" ry="3.7" fill="#BF9A75" />
            <ellipse cx="11.9" cy="15.2" rx="0.85" ry="0.7" fill="#4A3524" />
            <ellipse cx="16.1" cy="15.2" rx="0.85" ry="0.7" fill="#4A3524" />
            <path d="M14 16.6 v1.5" stroke="#4A3524" strokeWidth="0.75" strokeLinecap="round" />
        </g>
    );
}

function Duck({ asleep }: { asleep: boolean }) {
    return (
        <g>
            <path d="M13 3.4 q2.6 -2.2 4 0.6 q-1.9 0.9 -4 -0.6Z" fill="#F5C542" />
            <ellipse cx="14" cy="12.2" rx="8.8" ry="8.2" fill="#FFD84D" />
            <Eyes closed={asleep} />
            <path d="M9.6 14.6 q4.4 3.1 8.8 0 q-4.4 4.4 -8.8 0Z" fill="#F0872A" />
            <Blush />
        </g>
    );
}

function Penguin({ asleep }: { asleep: boolean }) {
    return (
        <g>
            <ellipse cx="14" cy="12" rx="9" ry="8.4" fill="#2E3440" />
            <ellipse cx="14" cy="13.8" rx="6" ry="6.2" fill="#F4F6F8" />
            <ellipse cx="9.9" cy="11.3" rx="2.5" ry="2.7" fill="#F4F6F8" />
            <ellipse cx="18.1" cy="11.3" rx="2.5" ry="2.7" fill="#F4F6F8" />
            <Eyes closed={asleep} />
            <path d="M11.9 15 h4.2 l-2.1 2.3 Z" fill="#F5A524" />
            <Blush />
        </g>
    );
}

function Frog({ asleep }: { asleep: boolean }) {
    return (
        <g>
            <circle cx="8.4" cy="6.2" r="3.4" fill="#7BC96F" />
            <circle cx="19.6" cy="6.2" r="3.4" fill="#7BC96F" />
            {asleep ? (
                <>
                    <path d="M6.9 6.4 q1.5 1.3 3 0" stroke="#12121a" strokeWidth="1.1" fill="none" strokeLinecap="round" />
                    <path d="M18.1 6.4 q1.5 1.3 3 0" stroke="#12121a" strokeWidth="1.1" fill="none" strokeLinecap="round" />
                </>
            ) : (
                <>
                    <ellipse className="sd-pet-blink" cx="8.4" cy="6.2" rx="1.4" ry="1.6" fill="#12121a" />
                    <ellipse className="sd-pet-blink" cx="19.6" cy="6.2" rx="1.4" ry="1.6" fill="#12121a" />
                </>
            )}
            <ellipse cx="14" cy="13.6" rx="9.2" ry="7.4" fill="#8FD97F" />
            <path d="M8.6 15.4 q5.4 4 10.8 0" stroke="#3F7A38" strokeWidth="1.1" fill="none" strokeLinecap="round" />
            <Blush />
        </g>
    );
}

const ART: Record<Exclude<IslandPetId, 'none'>, (p: { asleep: boolean }) => JSX.Element> = {
    cat: Cat,
    dog: Dog,
    capybara: Capybara,
    duck: Duck,
    penguin: Penguin,
    frog: Frog,
};

export function IslandPetArt({ id, mood, size = 28 }: {
    id: IslandPetId;
    mood: PetMood;
    size?: number;
}) {
    if (id === 'none') return null;
    const Art = ART[id];
    const asleep = mood === 'sleepy';

    return (
        <svg
            viewBox="0 0 28 21"
            width={size}
            height={size * (21 / 28)}
            className={`sd-pet sd-pet-${mood}`}
            aria-hidden
            focusable="false"
        >
            <Art asleep={asleep} />
        </svg>
    );
}
