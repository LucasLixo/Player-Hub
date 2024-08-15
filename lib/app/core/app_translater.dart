import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'pt_BR': {
      'app_language': 'Português',
      'home_tab1': 'Músicas',
      'home_tab2': 'Pastas',
      'home_tab3': 'Playlist',
      'home_tab4': 'Recentes',
      'home_not_tab1': 'Sem músicas',
      'home_not_tab2': 'Sem pastas',
      'home_not_tab3': 'Sem playlist',
      'home_not_tab4': 'Sem recentes',
      'setting_title': 'Configurações',
      'setting_ignore': 'Ignorar áudio menores que: @seconds segundos',
      'setting_mode': 'Modo escuro',
    },
    'en_US': {
      'app_language': 'English',
      'home_tab1': 'Music',
      'home_tab2': 'Folders',
      'home_tab3': 'Playlist',
      'home_tab4': 'Recents',
      'home_not_tab1': 'No music',
      'home_not_tab2': 'No folders',
      'home_not_tab3': 'No playlist',
      'home_not_tab4': 'No recents',
      'setting_title': 'Settings',
      'setting_ignore': 'Ignore audio shorter than: @seconds seconds',
      'setting_mode': 'Mode dark',
    },
    'es_ES': {
      'app_language': 'Español',
      'home_tab1': 'Música',
      'home_tab2': 'Carpetas',
      'home_tab3': 'Lista de reproducción',
      'home_tab4': 'Recientes',
      'home_not_tab1': 'Sin música',
      'home_not_tab2': 'Sin carpetas',
      'home_not_tab3': 'Sin lista de reproducción',
      'home_not_tab4': 'Sin recientes',
      'setting_title': 'Configuraciones',
      'setting_ignore': 'Ignorar audio más corto de: @seconds segundos',
      'setting_mode': 'Modo oscuro',
    },
  };
}
