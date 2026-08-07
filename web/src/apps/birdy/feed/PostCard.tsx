import { useState } from 'react';
import { Heart, MessageCircle, MoreHorizontal, Repeat2 } from 'lucide-react';

import { t } from '@/i18n';
import { AlertDialog } from '@/ui/AlertDialog';
import { LIKE, META, REPOST, relativeTime, type BirdyPost } from '../data';
import { compactCount } from '../polish/format';
import { HeartBurst } from '../polish/HeartBurst';
import { Avatar, PostImages, RichText, VerifiedBadge } from '../ui';

export function PostCard({ post, isOwn, onToggleLike, onToggleRepost, onOpen, onOpenAuthor, onDelete }: {
    post:          BirdyPost;
    isOwn:         boolean;
    onToggleLike:  () => void;
    onToggleRepost?: () => void;
    onOpen?:       () => void;
    onOpenAuthor?: (handle: string) => void;
    onDelete?:     () => void;
}) {
    const openAuthor = (e: React.MouseEvent) => {
        if (!onOpenAuthor) return;
        e.stopPropagation();
        onOpenAuthor(post.author.handle);
    };

    // Server truth; the parent applies the optimistic flip.
    const reposted = post.reposted === true;
    const [confirmRepost, setConfirmRepost] = useState(false);
    const [menuOpen, setMenuOpen] = useState(false);
    const repostCount = post.reposts;

    return (
        <>
        <article
            onClick={onOpen}
            className={`relative flex gap-4 border-b border-hairline/10 px-4 py-[18px] ${onOpen ? 'cursor-pointer transition-colors hover:bg-hairline/[0.04]' : ''}`}
        >
            {isOwn && onDelete && (
                // Absolute, not in the header row: as a flex sibling it stole width from the
                // handle and timestamp, so a post gaining this button visibly shifted its own text.
                <button
                    type="button"
                    onClick={e => { e.stopPropagation(); setMenuOpen(true); }}
                    className="absolute right-2 top-3 p-2 active:opacity-60"
                    aria-label={t('squawk.more', 'More')}
                    style={{ color: META }}
                >
                    <MoreHorizontal className="h-[22px] w-[22px]" />
                </button>
            )}

            <button type="button" onClick={openAuthor} className="h-fit shrink-0">
                <Avatar size={60} src={post.author.avatar} />
            </button>

            <div className="min-w-0 flex-1">
                {/* One line. The handle and time sit a size down from the name, which is what buys
                    the room: at a shared 19px this row needed ~334px and only ~300px exists beside
                    a 60px avatar. pr-7 keeps it clear of the absolutely positioned more button. */}
                <div className="flex items-baseline gap-1 pr-7 leading-tight">
                    <button type="button" onClick={openAuthor} className="flex min-w-0 items-baseline gap-1 text-left">
                        <span className="truncate text-[19px] font-bold text-label">{post.author.name}</span>
                        {post.author.verified && (
                            <span className="shrink-0 self-center"><VerifiedBadge size={18} type={post.author.verifiedType} /></span>
                        )}
                        <span className="truncate text-[15px]" style={{ color: META }}>@{post.author.handle}</span>
                    </button>
                    <span className="shrink-0 text-[15px]" style={{ color: META }}>· {relativeTime(post.createdAt)}</span>
                </div>

                {post.body && (
                    <p className="mt-1 whitespace-pre-wrap break-words text-[19px] leading-snug text-label">
                        <RichText text={post.body} />
                    </p>
                )}

                <PostImages images={post.images} />

                <div className="mt-4 flex max-w-[21rem] items-center justify-between">
                    <ActionButton
                        tone="comment"
                        icon={<MessageCircle className="h-[27px] w-[27px]" strokeWidth={1.9} />}
                        count={post.replies}
                        onClick={onOpen}
                    />
                    <ActionButton
                        tone="repost"
                        icon={<Repeat2 className="h-[29px] w-[29px]" strokeWidth={1.9} />}
                        count={repostCount}
                        color={reposted ? REPOST : undefined}
                        onClick={() => setConfirmRepost(true)}
                    />
                    <ActionButton
                        tone="like"
                        icon={
                            <HeartBurst liked={post.liked === true}>
                                <Heart
                                    className="h-[27px] w-[27px]"
                                    strokeWidth={1.9}
                                    fill={post.liked ? LIKE : 'none'}
                                    color={post.liked ? LIKE : 'currentColor'}
                                />
                            </HeartBurst>
                        }
                        count={post.likes}
                        color={post.liked ? LIKE : undefined}
                        onClick={onToggleLike}
                    />
                </div>
            </div>
        </article>

        {menuOpen && (
            <AlertDialog
                title={t('squawk.deletePost', 'Delete post?')}
                message={t('squawk.deletePostMessage', 'This removes the post and its replies for everyone. This cannot be undone.')}
                confirmLabel={t('squawk.delete', 'Delete')}
                destructive
                onCancel={() => setMenuOpen(false)}
                onConfirm={() => { setMenuOpen(false); onDelete?.(); }}
            />
        )}

        {confirmRepost && (
            <AlertDialog
                title={reposted ? t('squawk.undoRetweet', 'Undo Retweet') : t('squawk.retweet', 'Retweet')}
                message={reposted
                    ? t('squawk.removeRetweetMessage', "Remove your retweet of {name}'s post?", { name: post.author.name })
                    : t('squawk.retweetMessage', "Are you sure you want to retweet {name}'s post?", { name: post.author.name })}
                confirmLabel={reposted ? t('squawk.undo', 'Undo') : t('squawk.retweet', 'Retweet')}
                onCancel={() => setConfirmRepost(false)}
                onConfirm={() => { onToggleRepost?.(); setConfirmRepost(false); }}
            />
        )}
        </>
    );
}

const TONE: Record<'comment' | 'repost' | 'like', { text: string; bg: string }> = {
    comment: { text: 'group-hover:text-ios-blue', bg: 'group-hover:bg-ios-blue/10' },
    repost:  { text: 'group-hover:text-[#00ba7c]', bg: 'group-hover:bg-[#00ba7c]/10' },
    like:    { text: 'group-hover:text-[#f91880]', bg: 'group-hover:bg-[#f91880]/10' },
};

function ActionButton({ icon, count, color, tone, onClick }: {
    icon:     React.ReactNode;
    count:    number;
    color?:   string;
    tone:     'comment' | 'repost' | 'like';
    onClick?: () => void;
}) {
    const t = TONE[tone];
    const active = color != null;
    return (
        <button
            type="button"
            onClick={e => { e.stopPropagation(); onClick?.(); }}
            className={`group flex items-center gap-1 transition-transform active:scale-90 ${active ? '' : `text-ios-gray ${t.text}`}`}
            style={active ? { color } : undefined}
        >
            <span className={`-m-1.5 flex h-10 w-10 items-center justify-center rounded-full transition-colors ${t.bg}`}>
                {icon}
            </span>
            <span className="min-w-[1.5rem] text-left text-[16px] tabular-nums">{compactCount(count)}</span>
        </button>
    );
}
