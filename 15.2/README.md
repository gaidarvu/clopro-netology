# Домашнее задание к занятию «Вычислительные мощности. Балансировщики нагрузки»

### Задание 1. Yandex Cloud 

[Код Terraform, которым всё поднимал](.)

Бакет Object Storage (имя-студента-дата) с картинкой

![alt text](<pics/Screenshot 2025-04-20 233337.png>)

![alt text](<pics/Screenshot 2025-04-20 233407.png>)

![alt text](<pics/Screenshot 2025-04-20 233425.png>)

Группа ВМ в public подсети фиксированного размера с шаблоном LAMP и веб-страницей, содержащей ссылку на картинку из бакета

![alt text](<pics/Screenshot 2025-04-20 233742.png>)

![alt text](<pics/Screenshot 2025-04-20 233823.png>)

![alt text](<pics/Screenshot 2025-04-20 233315.png>)

Сетевой балансировщик.

![alt text](<pics/Screenshot 2025-04-20 233538.png>)

![alt text](<pics/Screenshot 2025-04-20 233604.png>)

После удаления одного из инстансов, одна из VM в таргет-группе перешла в состояние UNHEALTHY

![alt text](<pics/Screenshot 2025-04-20 234209.png>)

За тем через некорое время взамен удаленной VM начала подниматься реплика. По скольку я указал в scale_policy fixed_scale значение 3

![alt text](<pics/Screenshot 2025-04-20 234155.png>)

![alt text](<pics/Screenshot 2025-04-20 234226.png>)

[Код Terraform, которым всё поднимал](.)