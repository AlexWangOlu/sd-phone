import { describe, expect, it } from 'vitest';

import { detectFiveM, parseResourceName } from './nui';

describe('nui.detectFiveM', () => {
    it('detects a modern cfx-nui hostname after a reload strips the native', () => {
        expect(detectFiveM({ location: { hostname: 'cfx-nui-sd-phone', protocol: 'https:' } })).toBe(true);
    });

    it('detects a legacy nui: protocol origin', () => {
        expect(detectFiveM({ location: { hostname: 'sd-phone', protocol: 'nui:' } })).toBe(true);
    });

    it('detects the native function even without a NUI origin', () => {
        expect(detectFiveM({ GetParentResourceName: () => 'sd-phone', location: { hostname: 'localhost', protocol: 'http:' } })).toBe(true);
    });

    it('is false for a plain browser dev origin', () => {
        expect(detectFiveM({ location: { hostname: 'localhost', protocol: 'http:' } })).toBe(false);
        expect(detectFiveM({ location: { hostname: '127.0.0.1', protocol: 'http:' } })).toBe(false);
    });

    it('is false with no window', () => {
        expect(detectFiveM(undefined)).toBe(false);
    });
});

describe('nui.parseResourceName', () => {
    it('extracts the resource from a cfx-nui hostname when the native is gone', () => {
        expect(parseResourceName({ location: { hostname: 'cfx-nui-sd-phone', protocol: 'https:' } })).toBe('sd-phone');
    });

    it('prefers the native GetParentResourceName when present', () => {
        expect(parseResourceName({ GetParentResourceName: () => 'other-name', location: { hostname: 'cfx-nui-sd-phone' } })).toBe('other-name');
    });

    it('falls back to sd-phone off a NUI origin', () => {
        expect(parseResourceName({ location: { hostname: 'localhost', protocol: 'http:' } })).toBe('sd-phone');
        expect(parseResourceName(undefined)).toBe('sd-phone');
    });
});
