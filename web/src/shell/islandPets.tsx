import { t } from '@/i18n';

export type IslandPetId = 'none' | 'cat' | 'dog' | 'fox' | 'duck' | 'penguin' | 'frog';

export type PetMood = 'idle' | 'sleepy' | 'happy' | 'dancing' | 'startled';

export const ISLAND_PETS: readonly IslandPetId[] =
    ['none', 'cat', 'dog', 'fox', 'duck', 'penguin', 'frog'] as const;

export const SPRITE_W = 16;
export const SPRITE_H = 13;

interface Palette {
    B: string;
    D: string;
    L: string;
    E: string;
    A: string;
}

interface PetSprite {
    palette: Palette;
    walk:    [string[], string[]];
    sit:     string[];
}

const CAT: PetSprite = {
    palette: { B: '#E8963C', D: '#B4661F', L: '#FFE0B8', E: '#241A12', A: '#FF9FB4' },
    walk: [[
        '................',
        '..D...D.........',
        '..DBD.DBD.......',
        '..DBBBBBD.....D.',
        '..BBEBBEB.....DB',
        '..BBBABBB....DB.',
        '.DBBBBBBBBBBBB..',
        '.BBBBBBBBBBBBB..',
        '.BLLLLLLLLLLB...',
        '.BBBBBBBBBBB....',
        '..D.D....D.D....',
        '..D.D....D.D....',
        '................',
    ], [
        '................',
        '..D...D.........',
        '..DBD.DBD.......',
        '..DBBBBBD......D',
        '..BBEBBEB.....DB',
        '..BBBABBB....DB.',
        '.DBBBBBBBBBBBB..',
        '.BBBBBBBBBBBBB..',
        '.BLLLLLLLLLLB...',
        '.BBBBBBBBBBB....',
        '...DD......DD...',
        '..D..D....D..D..',
        '................',
    ]],
    sit: [
        '................',
        '..D...D.........',
        '..DBD.DBD.......',
        '..DBBBBBD.......',
        '..BBEBBEB.....D.',
        '..BBBABBB....DB.',
        '.DBBBBBBBBBBBB..',
        '.BBBBBBBBBBBB...',
        '.BLLLLLLLLLB....',
        '.BBBBBBBBBBB....',
        '.BBBBBBBBBBB....',
        '..DDDDDDDDD.....',
        '................',
    ],
};

const DOG: PetSprite = {
    palette: { B: '#C08A4E', D: '#7A5330', L: '#F3E2C8', E: '#241A12', A: '#3A2A1E' },
    walk: [[
        '................',
        '.DD.............',
        '.DBD............',
        '.DBBBBBD......D.',
        '.DBBEBBBD....DB.',
        '.DBBBBBBAD..DB..',
        '.DDBBBBBB.BBBB..',
        '.BBBBBBBBBBBBB..',
        '.BLLLLLLLLLLB...',
        '.BBBBBBBBBBB....',
        '..D.D....D.D....',
        '..D.D....D.D....',
        '................',
    ], [
        '................',
        '.DD.............',
        '.DBD............',
        '.DBBBBBD.......D',
        '.DBBEBBBD.....DB',
        '.DBBBBBBAD...DB.',
        '.DDBBBBBB.BBBB..',
        '.BBBBBBBBBBBBB..',
        '.BLLLLLLLLLLB...',
        '.BBBBBBBBBBB....',
        '...DD......DD...',
        '..D..D....D..D..',
        '................',
    ]],
    sit: [
        '................',
        '.DD.............',
        '.DBD............',
        '.DBBBBBD........',
        '.DBBEBBBD.....D.',
        '.DBBBBBBAD...DB.',
        '.DDBBBBBB.BBBB..',
        '.BBBBBBBBBBBB...',
        '.BLLLLLLLLLB....',
        '.BBBBBBBBBBB....',
        '.BBBBBBBBBBB....',
        '..DDDDDDDDD.....',
        '................',
    ],
};

const FOX: PetSprite = {
    palette: { B: '#E8702A', D: '#A8431A', L: '#FFF3E4', E: '#241A12', A: '#241A12' },
    walk: [[
        '................',
        '..D...D.........',
        '..DBD.DBD.......',
        '..DBBBBBD.....LL',
        '..BBEBBEB....LLL',
        '..BLLALLB...LLB.',
        '.DBBBBBBBBBBBB..',
        '.BBBBBBBBBBBBB..',
        '.BLLLLLLLLLLB...',
        '.BBBBBBBBBBB....',
        '..D.D....D.D....',
        '..D.D....D.D....',
        '................',
    ], [
        '................',
        '..D...D.........',
        '..DBD.DBD.......',
        '..DBBBBBD......L',
        '..BBEBBEB.....LL',
        '..BLLALLB....LLB',
        '.DBBBBBBBBBBBB..',
        '.BBBBBBBBBBBBB..',
        '.BLLLLLLLLLLB...',
        '.BBBBBBBBBBB....',
        '...DD......DD...',
        '..D..D....D..D..',
        '................',
    ]],
    sit: [
        '................',
        '..D...D.........',
        '..DBD.DBD.......',
        '..DBBBBBD.....LL',
        '..BBEBBEB....LLL',
        '..BLLALLB...LLB.',
        '.DBBBBBBBBBBB...',
        '.BBBBBBBBBBBB...',
        '.BLLLLLLLLLB....',
        '.BBBBBBBBBBB....',
        '.BBBBBBBBBBB....',
        '..DDDDDDDDD.....',
        '................',
    ],
};

const DUCK: PetSprite = {
    palette: { B: '#FFD84D', D: '#D9A62B', L: '#FFF0B8', E: '#241A12', A: '#F0872A' },
    walk: [[
        '................',
        '....DBBBD.......',
        '...DBBBBBD......',
        '..AABBEBBBD.....',
        '..AAABBBBBD.....',
        '....DBBBBBD.....',
        '...DBBBBBBBD....',
        '..DBBBBBBBBBD...',
        '..DBLLLLLLBBD...',
        '..DBBBBBBBBBD...',
        '...DDBBBBBDD....',
        '....A......A....',
        '...AAA...AAA....',
    ], [
        '................',
        '....DBBBD.......',
        '...DBBBBBD......',
        '..AABBEBBBD.....',
        '..AAABBBBBD.....',
        '....DBBBBBD.....',
        '...DBBBBBBBD....',
        '..DBBBBBBBBBD...',
        '..DBLLLLLLBBD...',
        '..DBBBBBBBBBD...',
        '...DDBBBBBDD....',
        '.....A....A.....',
        '....AAA..AAA....',
    ]],
    sit: [
        '................',
        '....DBBBD.......',
        '...DBBBBBD......',
        '..AABBEBBBD.....',
        '..AAABBBBBD.....',
        '....DBBBBBD.....',
        '...DBBBBBBBD....',
        '..DBBBBBBBBBD...',
        '..DBLLLLLLBBD...',
        '..DBBBBBBBBBD...',
        '...DBBBBBBBD....',
        '....DDDDDDD.....',
        '................',
    ],
};

const PENGUIN: PetSprite = {
    palette: { B: '#2E3440', D: '#171B22', L: '#F4F6F8', E: '#171B22', A: '#F5A524' },
    walk: [[
        '................',
        '....DBBBBD......',
        '...DBBBBBBD.....',
        '...DBLEBLEBD....',
        '...DBBAABBBD....',
        '...DBLLLLLBD....',
        '..DBLLLLLLLBD...',
        '..DBLLLLLLLBD...',
        '.DBBLLLLLLLBBD..',
        '..DBLLLLLLLBD...',
        '...DBLLLLLBD....',
        '....AA...AA.....',
        '...AAA...AAA....',
    ], [
        '................',
        '....DBBBBD......',
        '...DBBBBBBD.....',
        '...DBLEBLEBD....',
        '...DBBAABBBD....',
        '...DBLLLLLBD....',
        '..DBLLLLLLLBD...',
        '..DBLLLLLLLBD...',
        '.DBBLLLLLLLBBD..',
        '..DBLLLLLLLBD...',
        '...DBLLLLLBD....',
        '.....AA.AA......',
        '....AAA.AAA.....',
    ]],
    sit: [
        '................',
        '....DBBBBD......',
        '...DBBBBBBD.....',
        '...DBLEBLEBD....',
        '...DBBAABBBD....',
        '...DBLLLLLBD....',
        '..DBLLLLLLLBD...',
        '..DBLLLLLLLBD...',
        '.DBBLLLLLLLBBD..',
        '..DBLLLLLLLBD...',
        '...DBLLLLLBD....',
        '....DDDDDDD.....',
        '................',
    ],
};

const FROG: PetSprite = {
    palette: { B: '#7BC96F', D: '#3F7A38', L: '#D8F2CE', E: '#1A2416', A: '#E86A7C' },
    walk: [[
        '................',
        '..DD......DD....',
        '.DBBD....DBBD...',
        '.DBEBD..DBEBD...',
        '.DBBBDDDDBBBD...',
        '..DBBBBBBBBD....',
        '.DBBBBBBBBBBD...',
        'DBBBBBBBBBBBBD..',
        'DBLLLLLLLLLLBD..',
        'DBBBBBBBBBBBBD..',
        '.DBBBBBBBBBBD...',
        '..DD......DD....',
        '.DD........DD...',
    ], [
        '................',
        '..DD......DD....',
        '.DBBD....DBBD...',
        '.DBEBD..DBEBD...',
        '.DBBBDDDDBBBD...',
        '..DBBBBBBBBD....',
        '.DBBBBBBBBBBD...',
        'DBBBBBBBBBBBBD..',
        'DBLLLLLLLLLLBD..',
        'DBBBBBBBBBBBBD..',
        '.DBBBBBBBBBBD...',
        '...DD....DD.....',
        '..DD......DD....',
    ]],
    sit: [
        '................',
        '..DD......DD....',
        '.DBBD....DBBD...',
        '.DBEBD..DBEBD...',
        '.DBBBDDDDBBBD...',
        '..DBBBBBBBBD....',
        '.DBBBBBBBBBBD...',
        'DBBBBBBBBBBBBD..',
        'DBLLLLLLLLLLBD..',
        'DBBBBBBBBBBBBD..',
        '.DBBBBBBBBBBD...',
        '..DDDDDDDDDD....',
        '................',
    ],
};

const SPRITES: Record<Exclude<IslandPetId, 'none'>, PetSprite> = {
    cat: CAT, dog: DOG, fox: FOX, duck: DUCK, penguin: PENGUIN, frog: FROG,
};

export function islandPetLabel(id: IslandPetId): string {
    switch (id) {
        case 'cat':     return t('shell.petCat', 'Cat');
        case 'dog':     return t('shell.petDog', 'Dog');
        case 'fox':     return t('shell.petFox', 'Fox');
        case 'duck':    return t('shell.petDuck', 'Duck');
        case 'penguin': return t('shell.petPenguin', 'Penguin');
        case 'frog':    return t('shell.petFrog', 'Frog');
        default:        return t('shell.petNone', 'Off');
    }
}

function Frame({ rows, palette, hidden }: { rows: string[]; palette: Palette; hidden?: boolean }) {
    const px: JSX.Element[] = [];
    for (let y = 0; y < rows.length; y++) {
        const row = rows[y];
        for (let x = 0; x < row.length; x++) {
            const ch = row[x] as keyof Palette | '.';
            if (ch === '.') continue;
            const fill = palette[ch];
            if (!fill) continue;
            px.push(<rect key={`${x}-${y}`} x={x} y={y} width={1} height={1} fill={fill} />);
        }
    }
    return <g style={hidden ? { visibility: 'hidden' } : undefined}>{px}</g>;
}

export function IslandPetArt({ id, mood, height = 26 }: {
    id: IslandPetId;
    mood: PetMood;
    height?: number;
}) {
    if (id === 'none') return null;
    const sprite = SPRITES[id];
    const still = mood === 'sleepy';
    const width = height * (SPRITE_W / SPRITE_H);

    return (
        <svg
            viewBox={`0 0 ${SPRITE_W} ${SPRITE_H}`}
            width={width}
            height={height}
            shapeRendering="crispEdges"
            className={`sd-pet sd-pet-${mood}`}
            aria-hidden
            focusable="false"
        >
            {still ? (
                <Frame rows={sprite.sit} palette={sprite.palette} />
            ) : (
                <>
                    <g className="sd-pet-fa"><Frame rows={sprite.walk[0]} palette={sprite.palette} /></g>
                    <g className="sd-pet-fb"><Frame rows={sprite.walk[1]} palette={sprite.palette} /></g>
                </>
            )}
        </svg>
    );
}
