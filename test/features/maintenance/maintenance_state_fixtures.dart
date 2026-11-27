/// メンテナンス中かどうかの状態のテストで使う、状態を返す Worker の URL と応答の JSON
library;

/// テストで状態を読む先として渡す URL
final stateURL =
    Uri.parse('https://service-maintenance.example.workers.dev/pilll');

/// message と button を持つメンテナンス中の応答 (状態を返す Worker が返す JSON)
const inMaintenanceWithButton = {
  'maintenance': true,
  'message': '復旧までお待ちください',
  'button': {'label': 'お知らせを見る', 'url': 'https://example.com/news'},
  'source': 'owner',
  'changedAt': '2026-11-25T07:00:00.000Z',
};

/// message も button も無いメンテナンス中の応答
const inMaintenanceWithoutButton = {
  'maintenance': true,
  'message': null,
  'button': null,
  'source': 'cost',
  'changedAt': '2026-11-25T07:00:00.000Z',
};

/// メンテナンス中でない応答
const notInMaintenance = {
  'maintenance': false,
  'message': null,
  'button': null,
  'source': 'owner',
  'changedAt': '2026-11-25T08:00:00.000Z',
};
