# Smartik

Мобільний застосунок для інтерактивного розвитку та освіти дітей.

---

## Автор

- **ПІБ:** Місарош Марія Василівна
- **Група:** ФЕС-42
- **Керівник:** ас. Каськун Олег Данилович
- **Дата виконання:** 2025

---

## Загальна інформація

- **Тип проєкту:** Мобільний застосунок
- **Мова програмування:** Swift (SwiftUI)
- **Фреймворки / Бібліотеки:** SwiftUI, Firebase (Authentication, Firestore), Core Data

---

## Опис функціоналу

- Реєстрація та вхід користувачів (батьківський акаунт)
- Створення профілю дитини: ім’я, вік, аватар
- Навчальні ігри:
    - Вивчення тварин (Guess the Animal)
    - Вивчення кольорів (Color Match)
    - Вивчення української абетки (Make a Word)
    - Вивчення основ математики (Math Game)
    - Гра на відповідність (Matching Numbers)
    - Гра для розвитку памʼяті (MemoryGame)
    - Гра для знаходження зайвого елементу (OddOneOut)
- Відстеження прогресу дитини
- Система нагород для мотивації дітей
- Офлайн-режим для базового функціоналу
- Батьківський контроль

---

## Основні файли та компоненти проєкту

| Клас / Файл                       | Призначення                                  |
|------------------------------------|----------------------------------------------|
| SmartikApp.swift                   | Точка входу в застосунок                     |
| AppState.swift                     | Управління глобальним станом                 |
| ContentView.swift                  | Головний контейнер навігації                 |
| AuthViewModel.swift                | Логіка аутентифікації та керування профілем  |
| GamesView.swift                    | Головний екран вибору ігор                   |
| HomeView.swift                     | Привітальний екран для дитини                |
| ProfileView.swift                  | Профіль дитини, доступ до налаштувань        |
| ChildSetupView.swift               | Створення/редагування профілю дитини         |
| StatisticsView.swift               | Перегляд результатів і досягнень             |
| MatchingNumbersView.swift          | Гра на відповідність чисел                   |
| MemoryGameView.swift               | Гра «Пам’ять»                                |
| GuessAnimalView.swift              | Гра «Вгадай тварину»                         |
| OddOneOutView.swift                | Гра «Хто зайвий?»                            |
| ColorMatchView.swift               | Гра «Вивчення кольорів»                      |
| MakeWordView.swift                 | Гра «Вивчення української абетки»            |
| MathView.swift                     | Гра «Математика»                             |
| GameCategory.swift / GameItem.swift| Опис категорій ігор та ігрових об'єктів      |
| User.swift                         | Модель користувача                           |
| CoreDataManager.swift              | Робота з локальним збереженням               |

---

## Як запустити проєкт "з нуля"

1. **Встановлення інструментів**
    - Xcode 15.0 або новіший
    - Swift 5.9+
    - Створіть проєкт у Firebase Console

2. **Клонування репозиторію**
    ```bash
    git clone https://github.com/misaroshm/smartik.git
    cd smartik
    ```

3. **Підключення Firebase**
    - Створіть проєкт у Firebase Console
    - Додайте iOS застосунок
    - Завантажте файл `GoogleService-Info.plist` і додайте його в Xcode

4. **Збірка і запуск**
    - Відкрити `Smartik.xcodeproj`
    - Вибрати цільовий пристрій
    - Натиснути Run (Cmd + R)

---

## Структура бази даних (Firestore)

```
Users (collection)
 └── UID (document)
      ├── email: String
      ├── fullname: String
      ├── childName: String
      ├── childAge: Number
      ├── avatarName: String
      ├── id: String
      ├── statistics (subcollection)
           └── gameId (document)
                ├── bestScore: Number
                ├── correctAnswer: Number
                ├── gamesPlayed: Number
                ├── totalQuestions: Number
```

---

## Екранна навігація

- Splash Screen → Login/Registration → Child Setup  
- Home (вітання) → Games → Profile → Settings  
- Вибір гри → Старт гри → Результати → Статистика

---

## Інструкція для користувача

1. Реєстрація або вхід у батьківський акаунт
2. Налаштування профілю дитини — вибір аватара, імені та віку
3. Вибір категорії навчальної гри
4. Проходження гри — дитина грає, набирає бали, покращує навички
5. Перегляд статистики досягнень дитини
6. Батьківські налаштування — зміна пароля, email, видалення акаунта

---

## Screenshots

- Екран створення профілю дитини
- Головний екран HomeView
- Вибір гри GamesView
- Процес гри (Matching Numbers, Memory, OddOneOut...)
- Статистика результатів

(Зображення знаходяться у папці `/screenshots/`)
