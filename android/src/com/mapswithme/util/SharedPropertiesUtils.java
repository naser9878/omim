package com.mapswithme.util;

import android.content.SharedPreferences;
import android.preference.PreferenceManager;

import com.mapswithme.maps.MwmApplication;
import com.mapswithme.maps.R;

import static com.mapswithme.util.Config.KEY_PREF_STATISTICS;

public final class SharedPropertiesUtils
{
  private static final String PREFS_SHOW_EMULATE_BAD_STORAGE_SETTING = "ShowEmulateBadStorageSetting";
  private static final String PREFS_BACKUP_WIDGET_EXPANDED = "BackupWidgetExpanded";
  private static final SharedPreferences PREFS
      = PreferenceManager.getDefaultSharedPreferences(MwmApplication.get());

  public static boolean isShowcaseSwitchedOnLocal()
  {
    return PreferenceManager.getDefaultSharedPreferences(MwmApplication.get())
        .getBoolean(MwmApplication.get().getString(R.string.pref_showcase_switched_on), false);
  }

  public static boolean isStatisticsEnabled()
  {
    return MwmApplication.prefs().getBoolean(KEY_PREF_STATISTICS, true);
  }

  public static void setStatisticsEnabled(boolean enabled)
  {
    MwmApplication.prefs().edit().putBoolean(KEY_PREF_STATISTICS, enabled).apply();
  }

  public static void setShouldShowEmulateBadStorageSetting(boolean show)
  {
    PREFS.edit().putBoolean(PREFS_SHOW_EMULATE_BAD_STORAGE_SETTING, show).apply();
  }

  public static boolean shouldShowEmulateBadStorageSetting()
  {
    return PREFS.getBoolean(PREFS_SHOW_EMULATE_BAD_STORAGE_SETTING, false);
  }

  public static boolean shouldEmulateBadExternalStorage()
  {
    String key = MwmApplication.get().getString(R.string.pref_emulate_bad_external_storage);
    return PREFS.getBoolean(key, false);
  }

  public static void setBackupWidgetExpanded(boolean expanded)
  {
    PREFS.edit().putBoolean(PREFS_BACKUP_WIDGET_EXPANDED, expanded).apply();
  }

  public static boolean getBackupWidgetExpanded()
  {
    return PREFS.getBoolean(PREFS_BACKUP_WIDGET_EXPANDED, true);
  }

  //Utils class
  private SharedPropertiesUtils()
  {
    throw new IllegalStateException("Try instantiate utility class SharedPropertiesUtils");
  }
}
