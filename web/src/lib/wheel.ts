export function shiftWheelDelta(e: { shiftKey: boolean; deltaY: number; deltaX: number }): number {
    if (!e.shiftKey) return 0;
    return e.deltaY || e.deltaX;
}

export function verticalScrollerFor(start: Element | null, root: Element | null): HTMLElement | null {
    let node: HTMLElement | null = start instanceof HTMLElement ? start : null;
    while (node) {
        const style = getComputedStyle(node);
        if (canScroll(style.overflowX) && node.scrollWidth > node.clientWidth) return null;
        if (canScroll(style.overflowY) && node.scrollHeight > node.clientHeight) return node;
        if (node === root) return null;
        node = node.parentElement;
    }
    return null;
}

function canScroll(overflow: string): boolean {
    return overflow === 'auto' || overflow === 'scroll';
}
