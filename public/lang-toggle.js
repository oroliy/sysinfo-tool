(() => {
    const translations = {
        en: {
            subtitle: 'A lightweight system information tool',
            description: 'Use the button below to view or download the script.',
            button: 'Download Script',
            runText: 'Run with one command:',
            toggleText: '中文'
        },
        zh: {
            subtitle: '一个轻量级的系统信息工具',
            description: '使用下面的按钮查看或下载脚本。',
            button: '下载脚本',
            runText: '一条命令即可运行：',
            toggleText: 'English'
        }
    };

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
            // Ignore storage failures (private mode / disabled storage).
        }
    };

    const getPreferredLanguage = () => {
        const saved = safeStorageGet('sysinfo_lang');
        if (saved === 'en' || saved === 'zh') return saved;
        return navigator.language.toLowerCase().startsWith('zh') ? 'zh' : 'en';
    };

    const applyLanguage = (lang) => {
        const text = translations[lang];
        document.documentElement.lang = lang === 'zh' ? 'zh-CN' : 'en';
        document.getElementById('subtitle').textContent = text.subtitle;
        document.getElementById('description').textContent = text.description;
        document.getElementById('download-btn').textContent = text.button;
        document.getElementById('run-text').textContent = text.runText;
        document.getElementById('lang-toggle').textContent = text.toggleText;
        safeStorageSet('sysinfo_lang', lang);
    };

    const toggleButton = document.getElementById('lang-toggle');
    if (!toggleButton) return;

    let currentLanguage = getPreferredLanguage();
    applyLanguage(currentLanguage);

    toggleButton.addEventListener('click', () => {
        currentLanguage = currentLanguage === 'en' ? 'zh' : 'en';
        applyLanguage(currentLanguage);
    });
})();
