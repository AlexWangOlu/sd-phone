import { t } from '@/i18n';

export interface CameraFilter {
    id:  string;
    css: string;
}

export const CAMERA_FILTERS: readonly CameraFilter[] = [
    { id: 'original',      css: 'none' },
    { id: 'vivid',         css: 'saturate(1.5) contrast(1.1)' },
    { id: 'vividWarm',     css: 'saturate(1.45) contrast(1.08) sepia(0.14) hue-rotate(-6deg)' },
    { id: 'vividCool',     css: 'saturate(1.45) contrast(1.08) hue-rotate(10deg) brightness(1.03)' },
    { id: 'dramatic',      css: 'contrast(1.35) saturate(0.85) brightness(0.95)' },
    { id: 'dramaticWarm',  css: 'contrast(1.3) saturate(0.9) sepia(0.2) brightness(0.96)' },
    { id: 'dramaticCool',  css: 'contrast(1.3) saturate(0.88) hue-rotate(14deg) brightness(0.95)' },
    { id: 'mono',          css: 'grayscale(1) contrast(1.08)' },
    { id: 'silvertone',    css: 'grayscale(1) sepia(0.16) contrast(0.96) brightness(1.08)' },
    { id: 'noir',          css: 'grayscale(1) contrast(1.45) brightness(0.9)' },
] as const;

export function filterLabel(id: string): string {
    switch (id) {
        case 'vivid':        return t('camera.filterVivid', 'Vivid');
        case 'vividWarm':    return t('camera.filterVividWarm', 'Vivid Warm');
        case 'vividCool':    return t('camera.filterVividCool', 'Vivid Cool');
        case 'dramatic':     return t('camera.filterDramatic', 'Dramatic');
        case 'dramaticWarm': return t('camera.filterDramaticWarm', 'Dramatic Warm');
        case 'dramaticCool': return t('camera.filterDramaticCool', 'Dramatic Cool');
        case 'mono':         return t('camera.filterMono', 'Mono');
        case 'silvertone':   return t('camera.filterSilvertone', 'Silvertone');
        case 'noir':         return t('camera.filterNoir', 'Noir');
        default:             return t('camera.filterOriginal', 'Original');
    }
}

export function filterCss(id: string): string {
    return CAMERA_FILTERS.find(f => f.id === id)?.css ?? 'none';
}
