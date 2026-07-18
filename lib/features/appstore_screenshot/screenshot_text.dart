/// App Store スクリーンショットのキャッチコピー定義。
///
/// タイトル・サブタイトルを言語（arb 言語コード）×ページ番号で引く。
/// コピー案は競合調査（tmp/research/report.md 5-A）の 5 枚構成に対応する。
/// ja / en と ASC 対象の全言語を定義し、未定義の言語は en にフォールバックする。
/// 言語を追加するときは [_copies] に 1 言語分の Map を追記するだけで済む。
class ScreenshotCopy {
  const ScreenshotCopy({
    required this.title,
    required this.subtitle,
    this.titleAccentWord,
  });

  /// 太字・大きく表示するタイトル。明示改行（\n）を含めてよい。
  final String title;

  /// タイトル下に表示する補足文。
  final String subtitle;

  /// タイトル内でアクセント色にする単語。[title] に含まれる場合のみ着色する。
  /// null の場合はタイトル全体を白で表示する。
  final String? titleAccentWord;

  /// 指定言語・ページのコピーを返す。
  ///
  /// 対象言語に定義が無ければ en、en にも無ければ p1 のコピーへフォールバックする。
  static ScreenshotCopy of({required String lang, required int page}) {
    return _copies[lang]?[page] ?? _copies['en']?[page] ?? _copies['en']![1]!;
  }

  /// 言語コード→ページ番号→コピーの対応表。
  ///
  /// 5-A の 5 枚構成:
  /// 1 社会的証明＋中核価値 / 2 ピルシート UI / 3 伏せた通知 /
  /// 4 複数回リマインド / 5 生理管理。
  static const Map<String, Map<int, ScreenshotCopy>> _copies = {
    'ja': {
      1: ScreenshotCopy(
        title: '14万人が使う\n飲み忘れ防止アプリ',
        subtitle: '毎日の服用時刻に、通知でそっとお知らせ。',
        titleAccentWord: '14万人',
      ),
      2: ScreenshotCopy(
        title: 'シートを見れば、\nどこまで飲んだか一目でわかる',
        subtitle: 'ピルシートをそのまま画面に再現。',
        titleAccentWord: '一目',
      ),
      3: ScreenshotCopy(
        title: '伏せた通知だから、\n誰にも気づかれない',
        subtitle: 'ロック画面に出ても、中身はわからない。',
        titleAccentWord: '伏せた通知',
      ),
      4: ScreenshotCopy(
        title: '飲み忘れても大丈夫。\n通知は何度も届く',
        subtitle: '服用するまで、くり返しお知らせします。',
        titleAccentWord: '何度も',
      ),
      5: ScreenshotCopy(
        title: 'ピルも生理も、\nこれひとつで管理',
        subtitle: '生理を記録すると、次の予定を自動で予測。',
        titleAccentWord: 'これひとつ',
      ),
    },
    'en': {
      1: ScreenshotCopy(
        title: 'Trusted by 140K+ users\nNever miss your pill',
        subtitle: 'A gentle reminder notification at every dose time.',
        titleAccentWord: '140K+',
      ),
      2: ScreenshotCopy(
        title: 'See your whole pack\nat a glance',
        subtitle: 'Your pill pack, recreated right on screen.',
        titleAccentWord: 'at a glance',
      ),
      3: ScreenshotCopy(
        title: 'Discreet reminders,\nno one sees what it\'s for',
        subtitle: 'Even on the lock screen, it stays private.',
        titleAccentWord: 'Discreet',
      ),
      4: ScreenshotCopy(
        title: 'Missed it?\nWe\'ll remind you again',
        subtitle: 'Reminders repeat until you take your pill.',
        titleAccentWord: 'again',
      ),
      5: ScreenshotCopy(
        title: 'Your pill and your period,\nall in one',
        subtitle: 'Log your period and the next date is predicted.',
        titleAccentWord: 'all in one',
      ),
    },
    'ar': {
      1: ScreenshotCopy(
        title: 'أكثر من 140 ألف مستخدم\nلن تفوّت جرعتك أبدًا',
        subtitle: 'تذكير لطيف عند موعد كل جرعة يوميًا.',
        titleAccentWord: '140 ألف',
      ),
      2: ScreenshotCopy(
        title: 'شاهدي شريط حبوبك\nبلمحة واحدة',
        subtitle: 'شريط الحبوب معروض تمامًا كما هو على الشاشة.',
        titleAccentWord: 'بلمحة واحدة',
      ),
      3: ScreenshotCopy(
        title: 'إشعارات مخفاة،\nلا يكتشفها أحد',
        subtitle: 'حتى في شاشة القفل، لا يظهر المحتوى.',
        titleAccentWord: 'مخفاة',
      ),
      4: ScreenshotCopy(
        title: 'نسيتِ جرعتك؟\nسنذكّرك مرارًا',
        subtitle: 'سنكرر التذكير حتى تتناولي الجرعة.',
        titleAccentWord: 'مرارًا',
      ),
      5: ScreenshotCopy(
        title: 'حبوبك ودورتك الشهرية،\nفي تطبيق واحد فقط',
        subtitle: 'سجلي دورتك وسيتوقع التطبيق موعدها القادم تلقائيًا.',
        titleAccentWord: 'تطبيق واحد',
      ),
    },
    'ca': {
      1: ScreenshotCopy(
        title: '140.000+ usuàries\nno obliden la píndola',
        subtitle: 'Un recordatori discret a l\'hora de cada presa.',
        titleAccentWord: '140.000+',
      ),
      2: ScreenshotCopy(
        title: 'D\'un cop d\'ull, veus\nper on vas al blister',
        subtitle: 'El teu blister, recreat a la pantalla.',
        titleAccentWord: 'D\'un cop d\'ull',
      ),
      3: ScreenshotCopy(
        title: 'Avisos discrets,\nningú sabrà de què són',
        subtitle: 'Fins i tot a la pantalla de bloqueig, és privat.',
        titleAccentWord: 'discrets',
      ),
      4: ScreenshotCopy(
        title: 'T\'has oblidat?\nT\'ho recordarem de nou',
        subtitle: 'Els avisos es repeteixen fins que la prens.',
        titleAccentWord: 'de nou',
      ),
      5: ScreenshotCopy(
        title: 'La píndola i la regla,\ntot en una sola app',
        subtitle: 'Registra la regla i predirem la propera data.',
        titleAccentWord: 'tot en una sola app',
      ),
    },
    'cs': {
      1: ScreenshotCopy(
        title: '140 000+ žen\nnezapomíná na pilulku',
        subtitle: 'Jemné upozornění v čase každé dávky.',
        titleAccentWord: '140 000+',
      ),
      2: ScreenshotCopy(
        title: 'Celý blistr\nna jeden pohled',
        subtitle: 'Váš blistr pilulek přímo na obrazovce.',
        titleAccentWord: 'na jeden pohled',
      ),
      3: ScreenshotCopy(
        title: 'Diskrétní připomenutí,\nnikdo nepozná, o co jde',
        subtitle: 'I na zamčené obrazovce zůstane v soukromí.',
        titleAccentWord: 'Diskrétní',
      ),
      4: ScreenshotCopy(
        title: 'Zapomněla jste?\nPřipomeneme vám to znovu',
        subtitle: 'Upozornění se opakuje, dokud si nevezmete pilulku.',
        titleAccentWord: 'znovu',
      ),
      5: ScreenshotCopy(
        title: 'Pilulky i menstruace\nvše v jedné aplikaci',
        subtitle: 'Zaznamenejte menstruaci, příště ji odhadneme automaticky.',
        titleAccentWord: 'vše v jedné aplikaci',
      ),
    },
    'da': {
      1: ScreenshotCopy(
        title: 'Brugt af 140.000+\nGlem aldrig din pille',
        subtitle: 'En stille påmindelse ved hver doseringstid.',
        titleAccentWord: '140.000+',
      ),
      2: ScreenshotCopy(
        title: 'Se hele pakken\nmed ét blik',
        subtitle: 'Din pillepakke, gengivet direkte på skærmen.',
        titleAccentWord: 'med ét blik',
      ),
      3: ScreenshotCopy(
        title: 'Diskrete påmindelser,\ningen ser hvad det er',
        subtitle: 'Selv på låseskærmen forbliver det privat.',
        titleAccentWord: 'Diskrete',
      ),
      4: ScreenshotCopy(
        title: 'Glemte du den?\nVi minder dig igen',
        subtitle: 'Påmindelser gentages, indtil du tager pillen.',
        titleAccentWord: 'igen',
      ),
      5: ScreenshotCopy(
        title: 'Pille og periode,\nsamlet ét sted',
        subtitle: 'Log din periode, og næste dato forudsiges automatisk.',
        titleAccentWord: 'samlet ét sted',
      ),
    },
    'de': {
      1: ScreenshotCopy(
        title: '140.000+ Nutzerinnen\nvertrauen Pilll',
        subtitle: 'Eine sanfte Erinnerung zu jeder Einnahmezeit.',
        titleAccentWord: '140.000+',
      ),
      2: ScreenshotCopy(
        title: 'Deine Pillenpackung\nauf einen Blick',
        subtitle: 'Deine Pillenpackung – originalgetreu auf dem Bildschirm.',
        titleAccentWord: 'auf einen Blick',
      ),
      3: ScreenshotCopy(
        title: 'Diskrete Erinnerungen,\nniemand sieht wofür',
        subtitle: 'Auch auf dem Sperrbildschirm bleibt es privat.',
        titleAccentWord: 'Diskrete',
      ),
      4: ScreenshotCopy(
        title: 'Verpasst? Kein Problem.\nWir erinnern dich wieder',
        subtitle: 'Die Erinnerung wiederholt sich, bis du sie nimmst.',
        titleAccentWord: 'wieder',
      ),
      5: ScreenshotCopy(
        title: 'Pille und Periode\nalles an einem Ort',
        subtitle: 'Erfasse deine Periode – der nächste Termin wird automatisch vorhergesagt.',
        titleAccentWord: 'alles an einem Ort',
      ),
    },
    'el': {
      1: ScreenshotCopy(
        title: '140.000+ χρήστριες\nδε ξεχνούν το χάπι',
        subtitle: 'Μια ήπια υπενθύμιση σε κάθε ώρα λήψης.',
        titleAccentWord: '140.000+',
      ),
      2: ScreenshotCopy(
        title: 'Δες όλη τη θήκη\nμε μια ματιά',
        subtitle: 'Η θήκη χαπιών σου, αναπαραγμένη στην οθόνη.',
        titleAccentWord: 'με μια ματιά',
      ),
      3: ScreenshotCopy(
        title: 'Διακριτική ειδοποίηση,\nκανείς δεν καταλαβαίνει',
        subtitle: 'Ακόμα και στην κλειδωμένη οθόνη, παραμένει μυστικό.',
        titleAccentWord: 'Διακριτική',
      ),
      4: ScreenshotCopy(
        title: 'Το ξέχασες;\nΘα σου θυμίζουμε ξανά',
        subtitle: 'Οι ειδοποιήσεις επαναλαμβάνονται μέχρι τη λήψη.',
        titleAccentWord: 'ξανά',
      ),
      5: ScreenshotCopy(
        title: 'Το χάπι και η περίοδος,\nόλα σε ένα',
        subtitle: 'Καταγράφεις την περίοδο, η επόμενη προβλέπεται αυτόματα.',
        titleAccentWord: 'όλα σε ένα',
      ),
    },
    'es': {
      1: ScreenshotCopy(
        title: '+140.000 usuarias\nnunca olvidan su píldora',
        subtitle: 'Un aviso discreto a la hora de tu toma diaria.',
        titleAccentWord: '+140.000',
      ),
      2: ScreenshotCopy(
        title: 'De un vistazo sabrás\ncuánto llevas tomado',
        subtitle: 'Tu blíster, recreado en la pantalla.',
        titleAccentWord: 'De un vistazo',
      ),
      3: ScreenshotCopy(
        title: 'Avisos discretos,\nnadie sabrá para qué son',
        subtitle: 'Ni en la pantalla de bloqueo se nota.',
        titleAccentWord: 'discretos',
      ),
      4: ScreenshotCopy(
        title: '¿Se te olvidó?\nTe avisamos varias veces',
        subtitle: 'Te lo recordamos hasta que la tomes.',
        titleAccentWord: 'varias veces',
      ),
      5: ScreenshotCopy(
        title: 'Tu píldora y tu período,\ntodo en una app',
        subtitle: 'Registra tu período; predecimos la próxima fecha.',
        titleAccentWord: 'todo en una app',
      ),
    },
    'fi': {
      1: ScreenshotCopy(
        title: '140 000+ käyttäjää\nEi enää unohduksia',
        subtitle: 'Saat hellän muistutuksen oikeaan aikaan, joka päivä.',
        titleAccentWord: '140 000+',
      ),
      2: ScreenshotCopy(
        title: 'Näet koko liuskan\nyhdellä silmäyksellä',
        subtitle: 'Pilleriliuskasi näkyy sellaisenaan ruudulla.',
        titleAccentWord: 'yhdellä silmäyksellä',
      ),
      3: ScreenshotCopy(
        title: 'Huomaamaton ilmoitus,\nkukaan ei arvaa syytä',
        subtitle: 'Pysyy yksityisenä myös lukitusnäytöllä.',
        titleAccentWord: 'Huomaamaton ilmoitus',
      ),
      4: ScreenshotCopy(
        title: 'Unohditko?\nMuistutamme uudelleen',
        subtitle: 'Muistutukset toistuvat, kunnes otat pillerin.',
        titleAccentWord: 'uudelleen',
      ),
      5: ScreenshotCopy(
        title: 'Pillerit ja kuukautiset,\nkaikki yhdessä paikassa',
        subtitle: 'Kirjaa kuukautisesi, niin seuraava ajankohta ennustetaan automaattisesti.',
        titleAccentWord: 'yhdessä paikassa',
      ),
    },
    'he': {
      1: ScreenshotCopy(
        title: '140,000+ משתמשות\nלא שוכחות יותר כדור',
        subtitle: 'תזכורת עדינה בכל שעת נטילה.',
        titleAccentWord: '140,000+',
      ),
      2: ScreenshotCopy(
        title: 'כל הגיליון שלך\nבמבט אחד בלבד',
        subtitle: 'גיליון הכדורים משוחזר על המסך.',
        titleAccentWord: 'במבט אחד',
      ),
      3: ScreenshotCopy(
        title: 'התראות דיסקרטיות\nשאף אחד לא יבין',
        subtitle: 'גם על מסך הנעילה, התוכן נשאר פרטי.',
        titleAccentWord: 'דיסקרטיות',
      ),
      4: ScreenshotCopy(
        title: 'שכחת כדור? לא נורא\nנזכיר לך שוב ושוב',
        subtitle: 'התזכורות חוזרות עד שתיקחי את הכדור.',
        titleAccentWord: 'שוב ושוב',
      ),
      5: ScreenshotCopy(
        title: 'הכדור והמחזור שלך\nהכל במקום אחד',
        subtitle: 'תעדי מחזור, ותקבלי תחזית אוטומטית לתאריך הבא.',
        titleAccentWord: 'הכל במקום אחד',
      ),
    },
    'hi': {
      1: ScreenshotCopy(
        title: '1.4 लाख+ का भरोसा\nभूलने से बचाने वाला ऐप',
        subtitle: 'हर दिन गोली के तय समय पर, धीरे से नोटिफिकेशन आता है।',
        titleAccentWord: '1.4 लाख+',
      ),
      2: ScreenshotCopy(
        title: 'शीट पर एक नज़र में\nपता चले कितनी गोली ली',
        subtitle: 'पिल शीट, स्क्रीन पर हूबहू दिखेगी।',
        titleAccentWord: 'एक नज़र में',
      ),
      3: ScreenshotCopy(
        title: 'गुप्त नोटिफिकेशन,\nकिसी को पता नहीं चलेगा',
        subtitle: 'लॉक स्क्रीन पर भी अंदर की बात छिपी रहेगी।',
        titleAccentWord: 'गुप्त नोटिफिकेशन',
      ),
      4: ScreenshotCopy(
        title: 'भूल गईं? कोई बात नहीं।\nबार-बार याद दिलाएंगे',
        subtitle: 'जब तक गोली नहीं लेतीं, नोटिफिकेशन बार-बार आता है।',
        titleAccentWord: 'बार-बार',
      ),
      5: ScreenshotCopy(
        title: 'पिल हो या पीरियड,\nसब कुछ बस एक ऐप में',
        subtitle: 'पीरियड दर्ज करते ही अगली तारीख अपने आप पता चलेगी।',
        titleAccentWord: 'बस एक ऐप में',
      ),
    },
    'hr': {
      1: ScreenshotCopy(
        title: '140 000+ korisnica\nne zaboravlja pilulu',
        subtitle: 'Nježna obavijest svaki dan podsjeti te na uzimanje pilule.',
        titleAccentWord: '140 000+',
      ),
      2: ScreenshotCopy(
        title: 'Cijeli blister\nna prvi pogled',
        subtitle: 'Tvoj blister s pilulama vjerno je prikazan na ekranu.',
        titleAccentWord: 'na prvi pogled',
      ),
      3: ScreenshotCopy(
        title: 'Diskretne obavijesti,\nnitko to neće znati',
        subtitle: 'Iako se prikaže na zaključanom ekranu, sadržaj ostaje skriven.',
        titleAccentWord: 'Diskretne obavijesti',
      ),
      4: ScreenshotCopy(
        title: 'Zaboravila si?\nPodsjetit ćemo te opet',
        subtitle: 'Podsjetnike šaljemo iznova, sve dok ne uzmeš pilulu.',
        titleAccentWord: 'opet',
      ),
      5: ScreenshotCopy(
        title: 'Pilula i menstruacija\nsve na jednom mjestu',
        subtitle: 'Bilježiš menstruaciju, a sljedeći termin predviđamo automatski.',
        titleAccentWord: 'sve na jednom mjestu',
      ),
    },
    'hu': {
      1: ScreenshotCopy(
        title: '140 000+ felhasználó\nNe hagyd ki a tablettát',
        subtitle: 'Gyengéd emlékeztető minden szedés idején.',
        titleAccentWord: '140 000+',
      ),
      2: ScreenshotCopy(
        title: 'Egy pillantás,\nés tudod, hol tartasz',
        subtitle: 'A tablettacsomagod pontos mása a képernyőn.',
        titleAccentWord: 'Egy pillantás',
      ),
      3: ScreenshotCopy(
        title: 'Diszkrét emlékeztetők,\nsenki sem veszi észre',
        subtitle: 'A zárolt képernyőn is titokban marad.',
        titleAccentWord: 'Diszkrét',
      ),
      4: ScreenshotCopy(
        title: 'Kihagytad?\nÚjra és újra szólunk',
        subtitle: 'Amíg be nem veszed, folyamatosan emlékeztetünk.',
        titleAccentWord: 'Újra és újra',
      ),
      5: ScreenshotCopy(
        title: 'Tabletta és menstruáció\nmind egy helyen',
        subtitle: 'Naplózd a menstruációt, és megjósoljuk a következőt.',
        titleAccentWord: 'mind egy helyen',
      ),
    },
    'id': {
      1: ScreenshotCopy(
        title: 'Dipercaya 140 Ribu+\nJangan lewatkan pilmu',
        subtitle: 'Notifikasi lembut mengingatkan setiap waktu minum pil.',
        titleAccentWord: '140 Ribu+',
      ),
      2: ScreenshotCopy(
        title: 'Sekali lihat strip,\nlangsung tahu progresmu',
        subtitle: 'Strip pilmu ditampilkan persis di layar.',
        titleAccentWord: 'Sekali lihat',
      ),
      3: ScreenshotCopy(
        title: 'Notifikasi rahasia,\ntak ada yang tahu isinya',
        subtitle: 'Bahkan di layar kunci, isinya tetap rahasia.',
        titleAccentWord: 'Notifikasi rahasia',
      ),
      4: ScreenshotCopy(
        title: 'Lupa minum? Tak masalah.\nNotifikasi berulang kali',
        subtitle: 'Pengingat akan terus berulang sampai kamu minum.',
        titleAccentWord: 'berulang kali',
      ),
      5: ScreenshotCopy(
        title: 'Pil dan menstruasi,\nkelola di satu aplikasi',
        subtitle: 'Catat menstruasimu, jadwal berikutnya diprediksi otomatis.',
        titleAccentWord: 'satu aplikasi',
      ),
    },
    'it': {
      1: ScreenshotCopy(
        title: '140K+ utenti\nnon dimenticano mai',
        subtitle: 'Un promemoria discreto per ogni assunzione.',
        titleAccentWord: '140K+',
      ),
      2: ScreenshotCopy(
        title: 'Il tuo blister,\nchiaro a colpo d\'occhio',
        subtitle: 'Il tuo blister, riprodotto sullo schermo.',
        titleAccentWord: 'a colpo d\'occhio',
      ),
      3: ScreenshotCopy(
        title: 'Notifiche discrete,\nnessuno se ne accorge',
        subtitle: 'Anche sulla schermata di blocco resta privato.',
        titleAccentWord: 'discrete',
      ),
      4: ScreenshotCopy(
        title: 'Dimenticata la pillola?\nte lo ricordiamo ancora',
        subtitle: 'Ti ricordiamo più volte, finché non la prendi.',
        titleAccentWord: 'ancora',
      ),
      5: ScreenshotCopy(
        title: 'Pillola e ciclo,\ntutto in un\'app',
        subtitle: 'Registra il ciclo e prevediamo la prossima data.',
        titleAccentWord: 'tutto in un\'app',
      ),
    },
    'ko': {
      1: ScreenshotCopy(
        title: '14만 명이 쓰는\n복용 알림 앱',
        subtitle: '매일 복용 시간을 알림으로 조용히 알려드려요.',
        titleAccentWord: '14만',
      ),
      2: ScreenshotCopy(
        title: '시트만 보면\n복용 현황이 한눈에',
        subtitle: '피임약 시트를 화면에 그대로 재현했어요.',
        titleAccentWord: '한눈에',
      ),
      3: ScreenshotCopy(
        title: '은밀한 알림이라\n아무도 눈치채지 못해요',
        subtitle: '잠금 화면에 떠도 내용은 알 수 없어요.',
        titleAccentWord: '은밀한 알림',
      ),
      4: ScreenshotCopy(
        title: '깜빡해도 괜찮아요\n알림이 계속 와요',
        subtitle: '복용할 때까지 알림을 반복해서 보내드려요.',
        titleAccentWord: '계속',
      ),
      5: ScreenshotCopy(
        title: '피임약도 생리도\n이 앱 하나로 관리',
        subtitle: '생리를 기록하면 다음 예정일을 자동으로 예측해요.',
        titleAccentWord: '이 앱 하나로',
      ),
    },
    'ms': {
      1: ScreenshotCopy(
        title: '140K+ pengguna percaya\nJangan lupa minum pil',
        subtitle: 'Peringatan lembut pada setiap waktu minum pil.',
        titleAccentWord: '140K+',
      ),
      2: ScreenshotCopy(
        title: 'Lihat pek pil anda\npada sekali imbas',
        subtitle: 'Pek pil anda dipaparkan semula terus pada skrin.',
        titleAccentWord: 'sekali imbas',
      ),
      3: ScreenshotCopy(
        title: 'Peringatan tersembunyi,\ntiada siapa perasan',
        subtitle: 'Kekal sulit walaupun pada skrin kunci.',
        titleAccentWord: 'Peringatan tersembunyi',
      ),
      4: ScreenshotCopy(
        title: 'Terlupa minum pil?\nKami ingatkan anda lagi',
        subtitle: 'Peringatan berulang sehingga anda minum pil.',
        titleAccentWord: 'lagi',
      ),
      5: ScreenshotCopy(
        title: 'Pil dan haid anda,\nsemua dalam satu',
        subtitle: 'Rekod haid anda, tarikh seterusnya diramal secara automatik.',
        titleAccentWord: 'semua dalam satu',
      ),
    },
    'nl': {
      1: ScreenshotCopy(
        title: '140K+ gebruikers\nmissen nooit hun pil',
        subtitle: 'Een zachte melding bij elk innamemoment.',
        titleAccentWord: '140K+',
      ),
      2: ScreenshotCopy(
        title: 'Zie je hele pilstrip\nin één oogopslag',
        subtitle: 'Je pilstrip, exact nagebouwd op je scherm.',
        titleAccentWord: 'in één oogopslag',
      ),
      3: ScreenshotCopy(
        title: 'Discrete meldingen,\nniemand weet waarvoor',
        subtitle: 'Ook op het vergrendelscherm blijft het privé.',
        titleAccentWord: 'Discrete',
      ),
      4: ScreenshotCopy(
        title: 'Gemist?\nWe herinneren je weer',
        subtitle: 'We blijven je herinneren tot je je pil inneemt.',
        titleAccentWord: 'weer',
      ),
      5: ScreenshotCopy(
        title: 'Je pil en je periode,\nallemaal in één app',
        subtitle: 'Registreer je periode, we voorspellen de volgende automatisch.',
        titleAccentWord: 'allemaal in één app',
      ),
    },
    'no': {
      1: ScreenshotCopy(
        title: 'Over 140K+ brukere\nGlem aldri pillen din',
        subtitle: 'En skånsom påminnelse ved hver doseringstid.',
        titleAccentWord: '140K+',
      ),
      2: ScreenshotCopy(
        title: 'Se hele pillebrettet\nmed ett blikk',
        subtitle: 'Pillebrettet ditt, gjenskapt rett på skjermen.',
        titleAccentWord: 'med ett blikk',
      ),
      3: ScreenshotCopy(
        title: 'Diskrete varsler,\ningen aner hva det er',
        subtitle: 'Selv på låseskjermen forblir det privat.',
        titleAccentWord: 'Diskrete',
      ),
      4: ScreenshotCopy(
        title: 'Glemte du en dose?\nVi minner deg igjen',
        subtitle: 'Påminnelser gjentas til du tar pillen.',
        titleAccentWord: 'igjen',
      ),
      5: ScreenshotCopy(
        title: 'Pillen og mensen din,\nalt på ett sted',
        subtitle: 'Registrer mensen, så forutsier appen neste dato.',
        titleAccentWord: 'alt på ett sted',
      ),
    },
    'pl': {
      1: ScreenshotCopy(
        title: '140 tys. użytkowników\nnie zapomina o tabletce',
        subtitle: 'Delikatne przypomnienie o porze przyjęcia tabletki.',
        titleAccentWord: '140 tys. użytkowników',
      ),
      2: ScreenshotCopy(
        title: 'Twój blister\njak na dłoni',
        subtitle: 'Blister tabletek dokładnie odwzorowany na ekranie.',
        titleAccentWord: 'jak na dłoni',
      ),
      3: ScreenshotCopy(
        title: 'Dyskretne przypomnienia,\nnikt się nie domyśli',
        subtitle: 'Nawet na ekranie blokady zachowuje prywatność.',
        titleAccentWord: 'Dyskretne przypomnienia',
      ),
      4: ScreenshotCopy(
        title: 'Zapomniałaś?\nPrzypomnimy ponownie',
        subtitle: 'Przypomnienia powtarzają się, aż zażyjesz tabletkę.',
        titleAccentWord: 'ponownie',
      ),
      5: ScreenshotCopy(
        title: 'Tabletki i okres,\nw jednej aplikacji',
        subtitle: 'Zapisz okres, a kolejny termin przewidzimy automatycznie.',
        titleAccentWord: 'w jednej aplikacji',
      ),
    },
    'pt': {
      1: ScreenshotCopy(
        title: 'Mais de 140 mil usuárias\nnunca esquecem a pílula',
        subtitle: 'Um lembrete gentil no horário de cada dose.',
        titleAccentWord: '140 mil',
      ),
      2: ScreenshotCopy(
        title: 'Veja sua cartela\ne saiba tudo num relance',
        subtitle: 'Sua cartela de pílulas, recriada na tela.',
        titleAccentWord: 'num relance',
      ),
      3: ScreenshotCopy(
        title: 'Lembretes discretos,\nsem que ninguém descubra',
        subtitle: 'Mesmo na tela de bloqueio, continua privado.',
        titleAccentWord: 'discretos',
      ),
      4: ScreenshotCopy(
        title: 'Esqueceu?\nAvisamos várias vezes',
        subtitle: 'Os lembretes se repetem até você tomar a pílula.',
        titleAccentWord: 'várias vezes',
      ),
      5: ScreenshotCopy(
        title: 'Pílula e menstruação,\ntudo em um só app',
        subtitle: 'Registre sua menstruação e preveja a próxima data automaticamente.',
        titleAccentWord: 'tudo em um só',
      ),
    },
    'ro': {
      1: ScreenshotCopy(
        title: '140K+ utilizatoare\nnu uită nicio pastilă',
        subtitle: 'O notificare blândă la fiecare oră de administrare.',
        titleAccentWord: '140K+',
      ),
      2: ScreenshotCopy(
        title: 'Blisterul tău,\ndintr-o privire',
        subtitle: 'Blisterul e recreat exact pe ecran.',
        titleAccentWord: 'dintr-o privire',
      ),
      3: ScreenshotCopy(
        title: 'Notificări discrete,\nnimeni nu află',
        subtitle: 'Rămâne privat chiar și pe ecranul de blocare.',
        titleAccentWord: 'discrete',
      ),
      4: ScreenshotCopy(
        title: 'Ai uitat o pastilă?\nÎți amintim din nou',
        subtitle: 'Notificările se repetă până iei pastila.',
        titleAccentWord: 'din nou',
      ),
      5: ScreenshotCopy(
        title: 'Pastila și ciclul,\ntotul într-o aplicație',
        subtitle: 'Notează ciclul și afli automat următoarea dată.',
        titleAccentWord: 'totul într-o aplicație',
      ),
    },
    'ru': {
      1: ScreenshotCopy(
        title: '140 000+ пользователей\nНе пропустите приём',
        subtitle: 'Нежное напоминание о каждом приёме.',
        titleAccentWord: '140 000+',
      ),
      2: ScreenshotCopy(
        title: 'Видно с первого взгляда,\nсколько таблеток выпито',
        subtitle: 'Блистер таблеток отображается прямо на экране.',
        titleAccentWord: 'с первого взгляда',
      ),
      3: ScreenshotCopy(
        title: 'Незаметные напоминания,\nникто не догадается',
        subtitle: 'Даже на экране блокировки никто не поймёт, что внутри.',
        titleAccentWord: 'Незаметные',
      ),
      4: ScreenshotCopy(
        title: 'Забыли выпить?\nНапомним снова и снова',
        subtitle: 'Напоминания приходят, пока вы не примете таблетку.',
        titleAccentWord: 'снова и снова',
      ),
      5: ScreenshotCopy(
        title: 'Таблетки и цикл —\nвсё в одном месте',
        subtitle: 'Записывайте цикл — мы предскажем следующую дату.',
        titleAccentWord: 'всё в одном месте',
      ),
    },
    'sk': {
      1: ScreenshotCopy(
        title: '140 000+ používateľov\nnezabudne na pilulku',
        subtitle: 'Jemné pripomenutie pri každej dávke.',
        titleAccentWord: '140 000+',
      ),
      2: ScreenshotCopy(
        title: 'Jedným pohľadom\nvidíš celý blister',
        subtitle: 'Presná kópia blistra priamo v aplikácii.',
        titleAccentWord: 'Jedným pohľadom',
      ),
      3: ScreenshotCopy(
        title: 'Diskrétne upozornenia,\nnikto nič netuší',
        subtitle: 'Súkromné aj na zamknutej obrazovke.',
        titleAccentWord: 'Diskrétne',
      ),
      4: ScreenshotCopy(
        title: 'Zabudla si?\nPripomenieme znova',
        subtitle: 'Pripomíname, kým si pilulku nevezmeš.',
        titleAccentWord: 'znova',
      ),
      5: ScreenshotCopy(
        title: 'Pilulka aj menštruácia\nv jednej aplikácii',
        subtitle: 'Zaznamenaj menštruáciu, dátum ďalšej predpovieme.',
        titleAccentWord: 'v jednej aplikácii',
      ),
    },
    'sv': {
      1: ScreenshotCopy(
        title: 'Betrodd av 140 000+\nMissa aldrig p-pillret',
        subtitle: 'En mild påminnelse, varje gång det är dags.',
        titleAccentWord: '140 000+',
      ),
      2: ScreenshotCopy(
        title: 'Se hela kartan\npå en blick',
        subtitle: 'Din p-pillerkarta, återskapad direkt på skärmen.',
        titleAccentWord: 'på en blick',
      ),
      3: ScreenshotCopy(
        title: 'Diskreta påminnelser,\ningen anar vad det är',
        subtitle: 'Även på låsskärmen förblir det privat.',
        titleAccentWord: 'Diskreta',
      ),
      4: ScreenshotCopy(
        title: 'Glömde du?\nVi påminner dig igen',
        subtitle: 'Påminnelserna upprepas tills du tar pillret.',
        titleAccentWord: 'igen',
      ),
      5: ScreenshotCopy(
        title: 'Piller och mens,\nallt på ett ställe',
        subtitle: 'Logga din mens, så förutspås nästa datum automatiskt.',
        titleAccentWord: 'allt på ett ställe',
      ),
    },
    'th': {
      1: ScreenshotCopy(
        title: '140,000+ คนไว้วางใจ\nแอปป้องกันลืมกินยา',
        subtitle: 'แจ้งเตือนเบาๆ ทุกครั้งที่ถึงเวลากินยา',
        titleAccentWord: '140,000+',
      ),
      2: ScreenshotCopy(
        title: 'ดูแผงยาแล้วรู้ทันที\nว่ากินไปถึงไหนแล้ว',
        subtitle: 'แผงยาคุมจำลองอยู่บนหน้าจอเลย',
        titleAccentWord: 'ทันที',
      ),
      3: ScreenshotCopy(
        title: 'แจ้งเตือนแบบปกปิด\nไม่มีใครรู้ว่าคืออะไร',
        subtitle: 'แม้ขึ้นหน้าจอล็อก ก็ไม่มีใครรู้เนื้อหา',
        titleAccentWord: 'ปกปิด',
      ),
      4: ScreenshotCopy(
        title: 'ลืมกินยาก็ไม่ต้องกังวล\nเราจะแจ้งเตือนซ้ำให้',
        subtitle: 'แจ้งเตือนซ้ำจนกว่าจะกินยา',
        titleAccentWord: 'ซ้ำ',
      ),
      5: ScreenshotCopy(
        title: 'ยาคุมและประจำเดือน\nจัดการได้ในแอปเดียว',
        subtitle: 'บันทึกประจำเดือน แล้วคาดการณ์รอบถัดไปอัตโนมัติ',
        titleAccentWord: 'แอปเดียว',
      ),
    },
    'tr': {
      1: ScreenshotCopy(
        title: '140.000+ kullanıcı\nilacını asla kaçırmıyor',
        subtitle: 'Her doz saatinde nazikçe hatırlatır.',
        titleAccentWord: '140.000+',
      ),
      2: ScreenshotCopy(
        title: 'Tek bakışta\nnerede kaldığını gör',
        subtitle: 'Blisterin, ekranında birebir aynısı.',
        titleAccentWord: 'Tek bakışta',
      ),
      3: ScreenshotCopy(
        title: 'Gizli bildirimler,\nkimse anlamaz',
        subtitle: 'Kilit ekranında bile içeriği görünmez.',
        titleAccentWord: 'Gizli bildirimler',
      ),
      4: ScreenshotCopy(
        title: 'Unutsan bile sorun yok,\nbildirim defalarca gelir',
        subtitle: 'Hapını alana kadar bildirim tekrarlanır.',
        titleAccentWord: 'defalarca',
      ),
      5: ScreenshotCopy(
        title: 'Hapın da reglin de,\ntek uygulamada',
        subtitle: 'Regl döngünü kaydet, sıradaki tarih otomatik tahmin edilir.',
        titleAccentWord: 'tek uygulamada',
      ),
    },
    'uk': {
      1: ScreenshotCopy(
        title: '140K+ користувачів\nне пропускають пігулки',
        subtitle: 'Щодня делікатно нагадуємо про час прийому.',
        titleAccentWord: '140K+',
      ),
      2: ScreenshotCopy(
        title: 'Вся упаковка\nодним поглядом',
        subtitle: 'Ваша упаковка пігулок — прямо на екрані.',
        titleAccentWord: 'одним поглядом',
      ),
      3: ScreenshotCopy(
        title: 'Приховані нагадування\nніхто не здогадається',
        subtitle: 'Навіть на екрані блокування це залишається приватним.',
        titleAccentWord: 'Приховані',
      ),
      4: ScreenshotCopy(
        title: 'Забули випити?\nНагадаємо знову',
        subtitle: 'Нагадування повторюються, доки ви не приймете пігулку.',
        titleAccentWord: 'знову',
      ),
      5: ScreenshotCopy(
        title: 'Пігулки й цикл\nвсе в одному',
        subtitle: 'Записуйте місячні — наступну дату передбачимо автоматично.',
        titleAccentWord: 'все в одному',
      ),
    },
    'vi': {
      1: ScreenshotCopy(
        title: '140.000+ người tin dùng\nỨng dụng nhắc uống thuốc',
        subtitle: 'Nhắc nhẹ nhàng đúng giờ uống thuốc mỗi ngày.',
        titleAccentWord: '140.000+',
      ),
      2: ScreenshotCopy(
        title: 'Nhìn vỉ thuốc,\nbiết ngay uống đến đâu',
        subtitle: 'Tái hiện vỉ thuốc y hệt ngay trên màn hình.',
        titleAccentWord: 'biết ngay',
      ),
      3: ScreenshotCopy(
        title: 'Thông báo kín đáo,\nkhông ai nhận ra',
        subtitle: 'Dù hiện trên màn hình khóa, không ai biết nội dung.',
        titleAccentWord: 'kín đáo',
      ),
      4: ScreenshotCopy(
        title: 'Quên uống? Không sao!\nchúng tôi sẽ nhắc lại',
        subtitle: 'Thông báo sẽ nhắc lại đến khi bạn uống thuốc.',
        titleAccentWord: 'nhắc lại',
      ),
      5: ScreenshotCopy(
        title: 'Thuốc và kỳ kinh nguyệt,\nchỉ trong một ứng dụng',
        subtitle: 'Ghi lại kỳ kinh, ứng dụng tự động dự đoán lần tới.',
        titleAccentWord: 'một ứng dụng',
      ),
    },
    'zh': {
      1: ScreenshotCopy(
        title: '超14万人使用\n告别漏服烦恼',
        subtitle: '每天服药时间，推送通知轻声提醒。',
        titleAccentWord: '14万人',
      ),
      2: ScreenshotCopy(
        title: '看一眼药板\n服用进度一目了然',
        subtitle: '把药板原样搬到手机屏幕上。',
        titleAccentWord: '一目了然',
      ),
      3: ScreenshotCopy(
        title: '隐蔽提醒，\n没人看得出来',
        subtitle: '即使锁屏显示，也看不出内容。',
        titleAccentWord: '隐蔽提醒',
      ),
      4: ScreenshotCopy(
        title: '忘记吃药也没关系\n提醒会反复发送',
        subtitle: '直到服药为止，通知会反复提醒。',
        titleAccentWord: '反复',
      ),
      5: ScreenshotCopy(
        title: '服药与生理期，\n一站式管理',
        subtitle: '记录生理期，自动预测下次时间。',
        titleAccentWord: '一站式',
      ),
    },
  };
}
