# Django models generated from docs/db.md
# Covers all 5 Access databases consolidated into Django apps.
#
# Apps layout:
#   dictionary/models.py  <- arabicWords tables
#   accounts/models.py    <- arabicUsers tables
#   search/models.py      <- arabicSearch tables
#   manager/models.py     <- arabicManager tables
#   logs/models.py        <- arabicLogs tables

from django.db import models
from django.contrib.auth.models import AbstractUser


# ─────────────────────────────────────────────────────────────
# accounts/models.py  (arabicUsers)
# ─────────────────────────────────────────────────────────────

class User(AbstractUser):
    """
    arabicUsers.users
    role: 0=anon, 1-2=registered, 3-5=contributor, 6-7=editor, 15=admin
    user_status: 1=active, 77=frozen, 88=suspended, 99=deleted
    """
    ROLE_ANONYMOUS    = 0
    ROLE_USER         = 1
    ROLE_CONTRIBUTOR  = 3
    ROLE_EDITOR       = 6
    ROLE_ADMIN        = 15

    STATUS_ACTIVE    = 1
    STATUS_FROZEN    = 77
    STATUS_SUSPENDED = 88
    STATUS_DELETED   = 99

    GENDER_MALE   = 1
    GENDER_FEMALE = 2

    name        = models.CharField(max_length=255, blank=True)
    role        = models.IntegerField(default=0)
    user_status = models.IntegerField(default=1)
    about       = models.TextField(blank=True)
    gender      = models.SmallIntegerField(null=True, blank=True)
    picture     = models.BooleanField(default=False)
    join_date_utc = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = "users"

    @property
    def is_team(self):
        return self.role >= 3

    @property
    def is_admin_user(self):
        return self.role >= 15


class AllowEdit(models.Model):
    """arabicUsers.allowEdit — feature flags / site switches."""
    site_name = models.CharField(max_length=100, primary_key=True)
    allowed   = models.BooleanField(default=True)

    class Meta:
        db_table = "allow_edit"


class LoginLog(models.Model):
    """arabicUsers.loginLog — login audit trail."""
    user          = models.ForeignKey(User, on_delete=models.CASCADE)
    login_time_utc = models.DateTimeField()

    class Meta:
        db_table = "login_log"


# ─────────────────────────────────────────────────────────────
# dictionary/models.py  (arabicWords)
# ─────────────────────────────────────────────────────────────

class Word(models.Model):
    """
    arabicWords.words — main dictionary entries.
    partOfSpeach: 0-9 (typo preserved from Access; use db_column)
    status: -1=suspect, 0=unchecked, 1=verified
    gender: 0=neutral, 1=masc, 2=fem, 3=unknown
    number: 0=uncountable, 1=singular, 2=dual, 3=plural, 4=unknown, 5=irrelevant, 6=collective
    binyan: 0-10 verb pattern (verbs only)
    """
    STATUS_SUSPECT   = -1
    STATUS_UNCHECKED = 0
    STATUS_VERIFIED  = 1

    hebrew              = models.CharField(max_length=255, blank=True)
    hebrew_def          = models.CharField(max_length=255, blank=True)
    hebrew_clean        = models.CharField(max_length=255, blank=True)
    hebrew_clean_more   = models.CharField(max_length=255, blank=True)
    arabic              = models.CharField(max_length=255, blank=True)
    arabic_word         = models.CharField(max_length=255, blank=True)
    arabic_clean        = models.CharField(max_length=255, blank=True)
    arabic_clean_more   = models.CharField(max_length=255, blank=True)
    arabic_heb          = models.CharField(max_length=255, blank=True)
    arabic_heb_clean    = models.CharField(max_length=255, blank=True)
    arabic_heb_clean_more = models.CharField(max_length=255, blank=True)
    pronunciation       = models.CharField(max_length=255, blank=True)
    part_of_speech      = models.SmallIntegerField(default=0, db_column="partOfSpeach")
    gender              = models.SmallIntegerField(default=0)
    number              = models.SmallIntegerField(default=0)
    binyan              = models.SmallIntegerField(default=0)
    status              = models.SmallIntegerField(default=0)
    show                = models.BooleanField(default=True)
    img_link            = models.CharField(max_length=500, blank=True)
    img_credit          = models.CharField(max_length=255, blank=True)
    info                = models.TextField(blank=True)
    example             = models.TextField(blank=True)
    search_string       = models.TextField(blank=True)
    creator             = models.ForeignKey(
        "accounts.User", null=True, blank=True,
        on_delete=models.SET_NULL, related_name="created_words"
    )
    creation_time_utc   = models.DateTimeField(null=True, blank=True)
    locked_utc          = models.CharField(max_length=100, blank=True)  # "UTC+userID" composite
    root                = models.CharField(max_length=255, blank=True)
    link                = models.URLField(max_length=500, blank=True)
    link_desc           = models.CharField(max_length=255, blank=True)
    dialect             = models.CharField(max_length=255, blank=True)
    origin              = models.CharField(max_length=255, blank=True)
    labels              = models.ManyToManyField("Label", through="WordLabel", blank=True)
    media               = models.ManyToManyField("Media", through="WordMedia", blank=True)

    class Meta:
        db_table = "words"

    def __str__(self):
        return self.hebrew or self.arabic_word or str(self.pk)


class Sentence(models.Model):
    """arabicWords.sentences — phrase/sentence examples."""
    hebrew          = models.CharField(max_length=500, blank=True)
    hebrew_clean    = models.CharField(max_length=500, blank=True)
    arabic          = models.CharField(max_length=500, blank=True)
    arabic_clean    = models.CharField(max_length=500, blank=True)
    arabic_heb      = models.CharField(max_length=500, blank=True)
    arabic_heb_clean = models.CharField(max_length=500, blank=True)
    info            = models.TextField(blank=True)
    creator         = models.ForeignKey(
        "accounts.User", null=True, blank=True, on_delete=models.SET_NULL
    )
    creation_time_utc = models.DateTimeField(null=True, blank=True)
    show            = models.BooleanField(default=True)
    status          = models.SmallIntegerField(default=0)
    words           = models.ManyToManyField(Word, through="WordSentence", blank=True)

    class Meta:
        db_table = "sentences"


class WordSentence(models.Model):
    """arabicWords.wordsSentences — junction words <-> sentences."""
    sentence = models.ForeignKey(Sentence, on_delete=models.CASCADE)
    word     = models.ForeignKey(Word, on_delete=models.CASCADE)
    location = models.IntegerField(null=True, blank=True)

    class Meta:
        db_table = "words_sentences"


class Label(models.Model):
    """arabicWords.labels — topic tags."""
    label_name = models.CharField(max_length=255)

    class Meta:
        db_table = "labels"
        ordering = ["label_name"]

    def __str__(self):
        return self.label_name


class WordLabel(models.Model):
    """arabicWords.wordsLabels — junction words <-> labels."""
    word  = models.ForeignKey(Word, on_delete=models.CASCADE)
    label = models.ForeignKey(Label, on_delete=models.CASCADE)

    class Meta:
        db_table = "words_labels"
        unique_together = [("word", "label")]


class Media(models.Model):
    """
    arabicWords.media — audio/video files.
    m_type: 1=YouTube, 21=clyp.it, 22=SoundCloud, 23=local OGG
    """
    TYPE_YOUTUBE    = 1
    TYPE_CLYPT      = 21
    TYPE_SOUNDCLOUD = 22
    TYPE_LOCAL_OGG  = 23

    m_type        = models.SmallIntegerField()
    m_link        = models.CharField(max_length=500)
    credit        = models.CharField(max_length=255, blank=True)
    credit_link   = models.URLField(max_length=500, blank=True)
    description   = models.TextField(blank=True)
    speaker       = models.ForeignKey(
        "accounts.User", null=True, blank=True, on_delete=models.SET_NULL
    )
    creation_time = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = "media"


class WordMedia(models.Model):
    """arabicWords.wordsMedia — junction words <-> media."""
    word  = models.ForeignKey(Word, on_delete=models.CASCADE)
    media = models.ForeignKey(Media, on_delete=models.CASCADE)

    class Meta:
        db_table = "words_media"


class WordRelation(models.Model):
    """
    arabicWords.wordsRelations — semantic relationships.
    relation_type codes: 0=other, 1=heb synonyms, 2=ar synonyms,
      3=singular/plural, 4=masc/fem, 5=antonyms, 6=similar-ar, 7=similar-heb,
      8=response, 10=multi-word, 12=heb meaning, 13=ar meaning,
      20=derived, 50=active participle, 52=passive participle, 54=verbal noun,
      60=passive, 99=duplication
    """
    word1         = models.ForeignKey(Word, on_delete=models.CASCADE, related_name="relations_from")
    word2         = models.ForeignKey(Word, on_delete=models.CASCADE, related_name="relations_to")
    relation_type = models.SmallIntegerField()

    class Meta:
        db_table = "words_relations"


class WordShort(models.Model):
    """arabicWords.wordsShort — single-char search optimization index."""
    s_str  = models.CharField(max_length=10)
    word   = models.ForeignKey(Word, on_delete=models.CASCADE)

    class Meta:
        db_table = "words_short"


class List(models.Model):
    """
    arabicWords.lists — user-created word lists.
    privacy: 0=private, 1=link-only, 2=public, 3=shared
    """
    PRIVACY_PRIVATE   = 0
    PRIVACY_LINK_ONLY = 1
    PRIVACY_PUBLIC    = 2
    PRIVACY_SHARED    = 3

    list_name         = models.CharField(max_length=255)
    list_desc         = models.TextField(blank=True)
    privacy           = models.SmallIntegerField(default=1)
    type              = models.SmallIntegerField(default=10)
    creator           = models.ForeignKey(
        "accounts.User", null=True, blank=True, on_delete=models.SET_NULL
    )
    creation_time_utc = models.DateTimeField(null=True, blank=True)
    last_update_utc   = models.DateTimeField(null=True, blank=True)
    view_cnt          = models.IntegerField(default=0)
    words             = models.ManyToManyField(Word, through="WordList", blank=True)
    bookmarked_by     = models.ManyToManyField(
        "accounts.User", through="ListUser", blank=True, related_name="bookmarked_lists"
    )

    class Meta:
        db_table = "lists"

    def __str__(self):
        return self.list_name


class WordList(models.Model):
    """arabicWords.wordsLists — junction words <-> lists with ordering."""
    list = models.ForeignKey(List, on_delete=models.CASCADE)
    word = models.ForeignKey(Word, on_delete=models.CASCADE)
    pos  = models.IntegerField(null=True, blank=True)

    class Meta:
        db_table = "words_lists"
        ordering = ["pos"]


class ListUser(models.Model):
    """arabicWords.listsUsers — lists bookmarked by users."""
    list = models.ForeignKey(List, on_delete=models.CASCADE)
    user = models.ForeignKey("accounts.User", on_delete=models.CASCADE)
    pos  = models.IntegerField(null=True, blank=True)

    class Meta:
        db_table = "lists_users"
        ordering = ["pos"]


class WordHistory(models.Model):
    """
    arabicWords.history — full audit trail of word edits.
    action: 1=new, 2=error report, 3=verified, 4=fix, 5=hide, 6=unhide, 7=archive, 8=restore
    """
    word       = models.ForeignKey(Word, on_delete=models.CASCADE, related_name="history")
    user       = models.ForeignKey(
        "accounts.User", null=True, blank=True, on_delete=models.SET_NULL
    )
    action     = models.SmallIntegerField()
    action_utc = models.DateTimeField()
    show_new   = models.BooleanField(null=True, blank=True)
    show_old   = models.BooleanField(null=True, blank=True)
    hebrew_new = models.CharField(max_length=255, blank=True)
    hebrew_old = models.CharField(max_length=255, blank=True)
    arabic_new = models.CharField(max_length=255, blank=True)
    arabic_old = models.CharField(max_length=255, blank=True)
    status_new = models.SmallIntegerField(null=True, blank=True)
    status_old = models.SmallIntegerField(null=True, blank=True)
    labels_new = models.TextField(blank=True)  # comma-separated label IDs
    labels_old = models.TextField(blank=True)
    # Additional New/Old pairs omitted for brevity — add as needed
    explain    = models.TextField(blank=True)

    class Meta:
        db_table = "history"
        ordering = ["-action_utc"]


# ─────────────────────────────────────────────────────────────
# search/models.py  (arabicSearch)
# ─────────────────────────────────────────────────────────────

class WordSearched(models.Model):
    """
    arabicSearch.wordsSearched — aggregate search term stats.
    result: 1=exact, 2=soundex, 9=no results; combined codes (11,21,91) also used.
    translated: classification label — never written via SQL, admin UI only.
    """
    typed        = models.CharField(max_length=255)
    search_count = models.IntegerField(default=0)
    result       = models.SmallIntegerField(null=True, blank=True)
    translated   = models.CharField(max_length=255, blank=True)

    class Meta:
        db_table = "words_searched"


class LatestSearched(models.Model):
    """arabicSearch.latestSearched — per-search event log."""
    search_time = models.DateTimeField()
    search      = models.ForeignKey(WordSearched, on_delete=models.CASCADE)

    class Meta:
        db_table = "latest_searched"
        ordering = ["-search_time"]


# ─────────────────────────────────────────────────────────────
# manager/models.py  (arabicManager)
# ─────────────────────────────────────────────────────────────

class Task(models.Model):
    """
    arabicManager.tasks — team task management.
    status: 1=in progress, 2=before next, 3=next, 9=future, 15=ideas, 42=done, 99=cancelled
    priority: 1=urgent, 2=important, 3=regular, 5=low, 99=none
    type: 0=unclassified, 1=admin, 10=new feature, 11=improvement, 12=bug fix,
          20=content-words, 21=content-media, 29=content-other
    section: 0=other, 1=search, 2=word page, 3=personal lists, 4=fixed lists, 5=games, 6=sentences
    """
    STATUS_IN_PROGRESS = 1
    STATUS_BEFORE_NEXT = 2
    STATUS_NEXT        = 3
    STATUS_FUTURE      = 9
    STATUS_IDEAS       = 15
    STATUS_DONE        = 42
    STATUS_CANCELLED   = 99

    title      = models.CharField(max_length=255)
    notes      = models.TextField(blank=True)
    project    = models.IntegerField(default=0)
    status     = models.SmallIntegerField(default=9)
    priority   = models.SmallIntegerField(default=3)
    type       = models.SmallIntegerField(default=0)
    section    = models.SmallIntegerField(default=0)
    private    = models.BooleanField(default=False)
    img        = models.BooleanField(default=False)
    date_start = models.DateTimeField(null=True, blank=True)
    date_edit  = models.DateTimeField(null=True, blank=True)
    date_end   = models.DateTimeField(null=True, blank=True)
    voters     = models.ManyToManyField(
        "accounts.User", through="TaskVoting", blank=True, related_name="voted_tasks"
    )

    class Meta:
        db_table = "tasks"
        ordering = ["priority", "-date_edit"]

    def __str__(self):
        return self.title


class SubTask(models.Model):
    """arabicManager.subTasks."""
    task    = models.ForeignKey(Task, on_delete=models.CASCADE, related_name="subtasks")
    title   = models.CharField(max_length=255)
    place   = models.IntegerField(default=0)
    is_done = models.BooleanField(default=False)

    class Meta:
        db_table = "sub_tasks"
        ordering = ["place"]


class TaskVoting(models.Model):
    """
    arabicManager.tasksVoting — one row per user per task voted.
    Max 3 active votes per user enforced in application code.
    """
    task = models.ForeignKey(Task, on_delete=models.CASCADE)
    user = models.ForeignKey("accounts.User", on_delete=models.CASCADE)

    class Meta:
        db_table = "tasks_voting"
        unique_together = [("task", "user")]


# NOTE: tasksVotes (stale aggregate) and tasksLabels (write-only orphan)
# are intentionally omitted. Consider dropping them during migration.


# ─────────────────────────────────────────────────────────────
# logs/models.py  (arabicLogs)
# ─────────────────────────────────────────────────────────────

class Monitor(models.Model):
    """
    arabicLogs.monitors — scheduled job health tracking.
    m_id: 1 = personal lists counter
    status: 1=OK, other=error
    """
    m_id       = models.IntegerField(primary_key=True)
    status     = models.SmallIntegerField(default=1)
    action_utc = models.DateTimeField()

    class Meta:
        db_table = "monitors"
