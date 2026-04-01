(() => {
    const subtitle = document.getElementById('subtitle');
    const description = document.getElementById('description');
    const runText = document.getElementById('run-text');
    const downloadBtn = document.getElementById('download-btn');
    const toggleButton = document.getElementById('lang-toggle');
    const copyBtn = document.getElementById('copy-btn');
    const copyStatus = document.getElementById('copy-status');
    const installCommand = document.getElementById('install-command');

    if (
        !subtitle || !description || !runText || !downloadBtn || !toggleButton ||
        !copyBtn || !copyStatus || !installCommand
    ) {
        return;
    }

    const translations = {
        en: {
            subtitle: 'A lightweight system information tool',
            description: 'Use the button below to view or download the script.',
            button: 'Download Script',
            runText: 'Run with one command:',
            toggleText: '中文',
            toggleLabel: '切换到中文',
            copyIdle: 'Copy',
            copySuccess: 'Copied',
            copyError: 'Copy failed'
        },
        zh: {
            subtitle: '一个轻量级的系统信息工具',
            description: '使用下面的按钮查看或下载脚本。',
            button: '下载脚本',
            runText: '一条命令即可运行：',
            toggleText: 'English',
            toggleLabel: 'Switch language to English',
            copyIdle: '复制',
            copySuccess: '已复制',
            copyError: '复制失败'
        }
    };

    const storageKey = 'sysinfo_lang';
    let resetCopyTimer = null;
    let currentLanguage = 'en';

    const safeStorageGet = (key) => {
        try {
            return localStorage.getItem(key);
        } catch (_error) {
            return null;
        }
    };

    const safeStorageSet = (key, value) => {
        try {
            localStorage.setItem(key, value);
        } catch (_error) {
            // Ignore storage failures.
        }
    };

    const getPreferredLanguage = () => {
        const saved = safeStorageGet(storageKey);
        if (saved === 'en' || saved === 'zh') {
            return saved;
        }
        return navigator.language.toLowerCase().startsWith('zh') ? 'zh' : 'en';
    };

    const setCopyState = (stateKey) => {
        const text = translations[currentLanguage];
        copyBtn.textContent = text[stateKey];
        copyStatus.textContent = stateKey === 'copyIdle' ? '' : text[stateKey];
    };

    const applyLanguage = (lang) => {
        const text = translations[lang];
        currentLanguage = lang;
        document.documentElement.lang = lang === 'zh' ? 'zh-CN' : 'en';
        subtitle.textContent = text.subtitle;
        description.textContent = text.description;
        downloadBtn.textContent = text.button;
        runText.textContent = text.runText;
        toggleButton.textContent = text.toggleText;
        toggleButton.setAttribute('aria-label', text.toggleLabel);
        setCopyState('copyIdle');
        safeStorageSet(storageKey, lang);
    };

    copyBtn.addEventListener('click', async () => {
        if (resetCopyTimer !== null) {
            clearTimeout(resetCopyTimer);
        }

        try {
            await navigator.clipboard.writeText(installCommand.textContent);
            setCopyState('copySuccess');
        } catch (_error) {
            setCopyState('copyError');
        }

        resetCopyTimer = window.setTimeout(() => {
            setCopyState('copyIdle');
            resetCopyTimer = null;
        }, 1500);
    });

    toggleButton.addEventListener('click', () => {
        applyLanguage(currentLanguage === 'en' ? 'zh' : 'en');
    });

    applyLanguage(getPreferredLanguage());
})();
