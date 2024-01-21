# Тестовое задание от Гринатом

Задание [тут](https://github.com/foxweb/greenatom-test).

## Мотивация

У меня итак есть проекты, которые можно показать, но это задание мне показалось простым и интересным, поэтому почему бы
не сделать. Некоторые вещи я не сделал или сделал на минималках, потому что соответствующие навыки продемонстрированы
в других репозиторях. Именно поэтому валидации самые простые, лишь бы показать разное поведение контроллера. И не стал
добавлять линтер и писать тесты. Умею покрывать до 90% в большом проекте.

## Анализ требований

Это микросервис, очевидно он будет взаимодействовать с другими микросервисами, поэтому каждую деталь из задания надо
выполнить строго. В то же время в задании дано много свободы, описано не все, поэтому в реальной работе взаимодействие
следовало бы согласовать полностью, а в рамках тестового задания недостающие вещи я додумал сам.

## Доработка задания

1. В зависимости от того, хотим мы создать одну запись или несколько, запрос следует писать по-разному.
2. Не описано, что делать в случае, когда часть пользователей не проходит валидацию. Я выбрал мультистатус. Кого
получилось добавить, добавляются. Для остальных сообщаются ошибки валидации.
3. Неизвестно, будет ли добавляться другой функционал в этот микросервис. А это влияет на выбор фреймворка. Выбрал
Rails, потому что больше опыта на нем и получилось быстрее. Могу написать второй вариант на Sinatra или Roda с
использованием Sequel и dry-rb. Для маленького сервиса поднимать рельсу однозначно не стоит.

## Сборка и запуск в development окружении

```bash
docker compose build --build-arg uid=`id -u` --build-arg gid=`id -g`
docker compose run --rm rails dockerize -wait tcp://db:5432 bundle exec rake db:setup
docker compose up
```

## Как пользоваться

Токен захардкожен в compose.yml.

### Добавить одну запись:

```bash
curl 'http://lvh.me:3000/people' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer secret' -d \
  '{
    "person": {
      "first_name": "John",
      "last_name": "The Great",
      "passport_series": "44 88",
      "passport_number": "12345",
      "passport_issued_by": "Moscow Head Dept.",
      "passport_issued_on": "2005-05-25"
    }
  }' | jq
```

Ответ:

```json
{
  "person": {
    "id": 11,
    "first_name": "John",
    "last_name": "The Great",
    "passport_series": "44 88",
    "passport_number": "12345",
    "passport_issued_by": "Moscow Head Dept.",
    "passport_issued_on": "2005-05-25",
    "created_at": "2024-01-20T17:13:03.001Z",
    "updated_at": "2024-01-20T17:13:03.001Z"
  },
  "url": "http://lvh.me:3000/people/11"
}
```

### Добавить несколько записей:

```bash
curl 'http://lvh.me:3000/people' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer secret' -d \
  '{
    "people":[
      {
        "first_name":"John",
        "last_name":"The Great",
        "passport_series":"44 88",
        "passport_number":"12345",
        "passport_issued_by":"Moscow Head Dept.",
        "passport_issued_on":"2005-05-25"
      },
      {
        "first_name":"",
        "last_name":"Fake Great without name",
        "passport_series":"44 88",
        "passport_number":"12345",
        "passport_issued_by":"Moscow Head Dept.",
        "passport_issued_on":"2005-05-25"
      }
  ]}' | jq
```

Ответ:

```json
{
  "inserted": [
    {
      "person": {
        "id": 12,
        "first_name": "John",
        "last_name": "The Great",
        "passport_series": "44 88",
        "passport_number": "12345",
        "passport_issued_by": "Moscow Head Dept.",
        "passport_issued_on": "2005-05-25",
        "created_at": "2024-01-20T17:15:43.285Z",
        "updated_at": "2024-01-20T17:15:43.285Z"
      },
      "url": "http://lvh.me:3000/people/12"
    }
  ],
  "failed": [
    {
      "person": {
        "id": null,
        "first_name": "",
        "last_name": "Fake Great without name",
        "passport_series": "44 88",
        "passport_number": "12345",
        "passport_issued_by": "Moscow Head Dept.",
        "passport_issued_on": "2005-05-25",
        "created_at": null,
        "updated_at": null
      },
      "errors": {
        "first_name": [
          "can't be blank"
        ]
      }
    }
  ]
}
```
