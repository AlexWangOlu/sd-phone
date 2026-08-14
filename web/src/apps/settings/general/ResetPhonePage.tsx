import { useState } from 'react';

import { t } from '@/i18n';
import { AlertDialog } from '@/ui/AlertDialog';
import { requestPhoneReset } from '@/core/phoneReset';
import { ListGroup, ListRow } from '@/ui/ListGroup';
import { SubPage } from '../SettingsSubPage';

export function ResetPhonePage({ onBack }: { onBack: () => void }) {
    const [confirm, setConfirm] = useState<'reset' | 'erase' | null>(null);

    return (
        <>
            <SubPage title={t('settings.resetPhone', 'Reset Phone')} onBack={onBack}>
                <ListGroup footer={t('settings.resetAllFooter', 'Resetting puts every setting back to default. It does not sign you out or remove anything you have installed.')}>
                    <ListRow
                        label={t('settings.resetAllSettings', 'Reset All Settings')}
                        destructive
                        onPress={() => setConfirm('reset')}
                    />
                </ListGroup>

                <ListGroup footer={t('settings.eraseAllFooter', 'This will permanently erase all content and settings. This action cannot be undone.')}>
                    <ListRow
                        label={t('settings.eraseAllContent', 'Erase All Content and Settings')}
                        destructive
                        onPress={() => setConfirm('erase')}
                    />
                </ListGroup>
            </SubPage>

            {confirm === 'reset' && (
                <AlertDialog
                    title={t('settings.resetAllTitle', 'Reset All Settings?')}
                    message={t('settings.resetAllMessage', 'Your theme, wallpaper, Home Screen layout and other preferences go back to default. Your apps, accounts, passcode and contact card are kept.')}
                    confirmLabel={t('settings.resetConfirm', 'Reset')}
                    destructive
                    onCancel={() => setConfirm(null)}
                    onConfirm={() => { setConfirm(null); requestPhoneReset('settings'); }}
                />
            )}

            {confirm === 'erase' && (
                <AlertDialog
                    title={t('settings.eraseAllTitle', 'Erase All Content and Settings?')}
                    message={t('settings.eraseAllMessage', 'Your phone will be wiped back to factory defaults. Server-side data (mail accounts, group memberships) is preserved — sign out / leave first if you want a complete reset.')}
                    confirmLabel={t('settings.eraseConfirm', 'Erase')}
                    destructive
                    onCancel={() => setConfirm(null)}
                    onConfirm={() => { setConfirm(null); requestPhoneReset('erase'); }}
                />
            )}
        </>
    );
}
