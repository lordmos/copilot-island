const https = require('https');
const fs = require('fs');
const path = require('path');

const REPO = 'lordmos/copilot-island';
const TARGET_DIR = path.join(__dirname, '../docs/public');
const APPCAST_PATH = path.join(TARGET_DIR, 'appcast.xml');

function log(msg) {
    console.log(`[Appcast Generator] ${msg}`);
}

function writeXML(xml) {
    if (!fs.existsSync(TARGET_DIR)) {
        fs.mkdirSync(TARGET_DIR, { recursive: true });
    }
    fs.writeFileSync(APPCAST_PATH, xml.trim() + '\n');
}

function createDummyAppcast() {
    log('Creating dummy appcast.xml as fallback...');
    const xml = `
<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0" xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle">
    <channel>
        <title>Copilot Island Changelog</title>
        <link>https://github.com/${REPO}</link>
        <description>No releases found yet.</description>
    </channel>
</rss>
`;
    writeXML(xml);
}

log(`Fetching latest release for ${REPO}...`);

const options = {
    hostname: 'api.github.com',
    path: `/repos/${REPO}/releases/latest`,
    headers: { 'User-Agent': 'Node.js/Appcast-Generator' }
};

https.get(options, (res) => {
    let data = '';
    res.on('data', (chunk) => { data += chunk; });
    res.on('end', () => {
        if (res.statusCode !== 200) {
            log(`Failed with status code: ${res.statusCode}. Outputting dummy.`);
            createDummyAppcast();
            return;
        }

        try {
            const release = JSON.parse(data);
            const version = release.tag_name.replace(/^v/, '');
            
            // Convert to RFC 2822 date for Sparkle (e.g. "Sat, 09 Aug 2014 20:30:40 +0000")
            const pubDate = new Date(release.published_at).toUTCString();
            const dmgAsset = release.assets.find(a => a.name.endsWith('.dmg'));
            
            if (!dmgAsset) {
                log(`No .dmg asset found in latest release (v${version}). Outputting dummy.`);
                createDummyAppcast();
                return;
            }
            
            const xml = `
<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0" xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle" xmlns:dc="http://purl.org/dc/elements/1.1/">
    <channel>
        <title>Copilot Island Changelog</title>
        <link>https://github.com/${REPO}</link>
        <description>Most recent changes with links to updates.</description>
        <item>
            <title>Version ${version}</title>
            <sparkle:releaseNotesLink>${release.html_url}</sparkle:releaseNotesLink>
            <pubDate>${pubDate}</pubDate>
            <enclosure url="${dmgAsset.browser_download_url}"
                       sparkle:version="${version}"
                       sparkle:shortVersionString="${version}"
                       length="${dmgAsset.size}"
                       type="application/octet-stream" />
        </item>
    </channel>
</rss>
`;
            
            writeXML(xml);
            log(`Successfully generated appcast.xml for v${version}`);
            
        } catch (err) {
            log(`Error parsing response: ${err.message}`);
            createDummyAppcast();
        }
    });
}).on('error', (err) => {
    log(`HTTP Request error: ${err.message}`);
    createDummyAppcast();
});
