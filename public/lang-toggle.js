(() => {
    const eyebrow = document.getElementById('eyebrow');
    const heroTitle = document.getElementById('hero-title');
    const heroDescription = document.getElementById('hero-description');
    const chipOne = document.getElementById('chip-one');
    const chipTwo = document.getElementById('chip-two');
    const chipThree = document.getElementById('chip-three');
    const runText = document.getElementById('run-text');
    const downloadBtn = document.getElementById('download-btn');
    const downloadMeta = document.getElementById('download-meta');
    const previewLabel = document.getElementById('preview-label');
    const previewNote = document.getElementById('preview-note');
    const statOneValue = document.getElementById('stat-one-value');
    const statOneLabel = document.getElementById('stat-one-label');
    const statTwoValue = document.getElementById('stat-two-value');
    const statTwoLabel = document.getElementById('stat-two-label');
    const toggleButton = document.getElementById('lang-toggle');
    const copyBtn = document.getElementById('copy-btn');
    const copyStatus = document.getElementById('copy-status');
    const installCommand = document.getElementById('install-command');

    if (
        !eyebrow || !heroTitle || !heroDescription || !chipOne || !chipTwo ||
        !chipThree || !runText || !downloadBtn || !downloadMeta || !previewLabel ||
        !previewNote || !statOneValue || !statOneLabel || !statTwoValue ||
        !statTwoLabel || !toggleButton || !copyBtn || !copyStatus || !installCommand
    ) {
        return;
    }

    const translations = {
        en: {
            eyebrow: 'Fast host diagnostics',
            heroTitle: 'Lightweight system facts, ready in one command.',
            heroDescription: 'A clean host snapshot for CPU, memory, disk, uptime, virtualization, and connectivity, without the usual benchmark noise.',
            chipOne: 'No benchmark clutter',
            chipTwo: 'Readable in seconds',
            chipThree: 'Shell-first workflow',
            runText: 'Install',
            button: 'Download Script',
            downloadMeta: 'MIT licensed, curl or wget install',
            previewLabel: 'Output preview',
            previewNote: 'The page centers the install command first, with a compact output panel to show what the script is for before users download it.',
            statOneValue: 'CPU',
            statOneLabel: 'Model, cores, and frequency',
            statTwoValue: 'Disk',
            statTwoLabel: 'Accurate storage and uptime context',
            toggleText: '中文',
            toggleLabel: 'Switch language to Chinese',
            copyIdle: 'Copy',
            copySuccess: 'Copied',
            copyError: 'Copy failed'
        },
        zh: {
            eyebrow: '快速主机诊断',
            heroTitle: '一条命令，拿到关键系统信息。',
            heroDescription: '快速查看 CPU、内存、磁盘、运行时长、虚拟化和网络连通性，不夹带冗余跑分信息。',
            chipOne: '没有跑分噪音',
            chipTwo: '几秒内读懂',
            chipThree: '面向 shell 工作流',
            runText: '安装命令',
            button: '下载脚本',
            downloadMeta: 'MIT 许可，支持 curl 或 wget 安装',
            previewLabel: '输出预览',
            previewNote: '页面把安装命令放在视觉中心，同时用右侧预览面板快速说明脚本能提供什么信息。',
            statOneValue: 'CPU',
            statOneLabel: '型号、核心数与频率',
            statTwoValue: '磁盘',
            statTwoLabel: '准确展示存储与运行时间上下文',
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
        return 'en';
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
        eyebrow.textContent = text.eyebrow;
        heroTitle.textContent = text.heroTitle;
        heroDescription.textContent = text.heroDescription;
        chipOne.textContent = text.chipOne;
        chipTwo.textContent = text.chipTwo;
        chipThree.textContent = text.chipThree;
        runText.textContent = text.runText;
        downloadBtn.textContent = text.button;
        downloadMeta.textContent = text.downloadMeta;
        previewLabel.textContent = text.previewLabel;
        previewNote.textContent = text.previewNote;
        statOneValue.textContent = text.statOneValue;
        statOneLabel.textContent = text.statOneLabel;
        statTwoValue.textContent = text.statTwoValue;
        statTwoLabel.textContent = text.statTwoLabel;
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
