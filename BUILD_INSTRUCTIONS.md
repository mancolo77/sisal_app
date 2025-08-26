# Инструкции по сборке Android APK

## GreenArena: Sports Sections Quiz

### Быстрый старт

1. **Проверьте настройки Flutter:**
   ```bash
   flutter doctor
   ```

2. **Установите зависимости:**
   ```bash
   flutter pub get
   ```

3. **Сгенерируйте код:**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Соберите APK:**
   ```bash
   # Debug версия (для тестирования)
   flutter build apk --debug
   
   # Release версия (для публикации)
   flutter build apk --release
   ```

### Расположение файлов

После успешной сборки APK файлы будут находиться в:

- **Debug**: `build/app/outputs/flutter-apk/app-debug.apk`
- **Release**: `build/app/outputs/flutter-apk/app-release.apk`

### Установка на устройство

#### Через ADB:
```bash
# Подключите Android устройство и включите отладку по USB
adb install build/app/outputs/flutter-apk/app-release.apk
```

#### Через файловый менеджер:
1. Скопируйте APK файл на устройство
2. Откройте файл через файловый менеджер
3. Разрешите установку из неизвестных источников
4. Нажмите "Установить"

### Запуск в эмуляторе

1. **Создайте эмулятор Android:**
   ```bash
   # Через Android Studio или командную строку
   avd
   ```

2. **Запустите приложение:**
   ```bash
   flutter run
   ```

### Требования к системе

- **Flutter**: 3.8+
- **Android SDK**: API 26+ (Android 8.0)
- **Gradle**: Автоматически управляется Flutter
- **Java**: OpenJDK 17+ (рекомендуется)

### Размер приложения

- **Debug APK**: ~15-25 MB
- **Release APK**: ~10-20 MB (с оптимизацией)

### Оптимизация размера

Для уменьшения размера APK:

```bash
# Сборка с разделением по архитектуре
flutter build apk --split-per-abi

# Сборка App Bundle (рекомендуется для Google Play)
flutter build appbundle
```

### Возможные проблемы

#### 1. Ошибка "Android licenses not accepted"
```bash
flutter doctor --android-licenses
# Принимайте все лицензии (введите 'y')
```

#### 2. Ошибка Gradle
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

#### 3. Проблемы с зависимостями
```bash
flutter pub deps
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Подпись APK (для релиза)

1. **Создайте keystore:**
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. **Настройте android/key.properties:**
   ```
   storePassword=<password>
   keyPassword=<password>
   keyAlias=upload
   storeFile=<path-to-keystore>
   ```

3. **Обновите android/app/build.gradle** (добавьте signing config)

4. **Соберите подписанный APK:**
   ```bash
   flutter build apk --release
   ```

### Тестирование

Перед релизом протестируйте:

1. **Основные функции:**
   - Навигация между экранами
   - Прохождение квиза
   - Просмотр результатов
   - Сохранение данных

2. **Производительность:**
   - Скорость запуска
   - Плавность анимаций
   - Потребление памяти

3. **Совместимость:**
   - Разные размеры экранов
   - Различные версии Android

### Публикация

Для публикации в Google Play Store:

1. Соберите App Bundle: `flutter build appbundle`
2. Загрузите в Google Play Console
3. Заполните метаданные приложения
4. Пройдите процесс проверки

### Контакты

При возникновении проблем со сборкой, проверьте:
- Официальную документацию Flutter
- Flutter GitHub Issues
- Stack Overflow с тегом `flutter`

---

**Удачной сборки! 🚀**
