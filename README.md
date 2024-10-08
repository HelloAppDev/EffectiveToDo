# EffectiveToDo
Главный экран при первом запуске приложения встречает с предзагруженными тудушками из dummyjson.com.
Такие тудушки представлены в виде названия и изображения с галочкой, если они отмечены, как выполненные и с пустым
изображением, если действие выполнено не было.

<img width="355" alt="mainScreen" src="https://github.com/user-attachments/assets/4f5822a7-534d-432d-a5cd-3e2c0cf521eb">

Для перехода на экран создания новой тудушки необходимо тапнуть на + в правой части таббара, а для редактирования тудушки
нужно тапнуть на нее саму в таблице.

<img width="358" alt="Снимок экрана 2024-08-28 в 04 29 40" src="https://github.com/user-attachments/assets/e8db7a06-6b8a-448e-b5b1-248cdffe1c1f">

Так выглядит экран создания новой тудушки. Для ее создания необходимо лишь указать ее тайтл (выполнение задачи и описание опциональны).
При попытке сохранить тудушку без заданного тайтла - Вы увидете сообщение об ошибке.

<img width="359" alt="ошибка" src="https://github.com/user-attachments/assets/b8d25c5c-cbd9-45a8-8a17-e622e9ac4883">

Для удобства кнопка Save всегда находится на виду, чтобы ее не перекрывала клавиатура при внесении изменений.

<img width="360" alt="Снимок экрана 2024-08-28 в 04 36 00" src="https://github.com/user-attachments/assets/33dc6790-fdc0-4ee0-ba1f-74a8c1087da5">

После успешного создания задачи по возвращении на главный экран свайпом влево по ячейке задачи Вы можете удалить ее.

<img width="353" alt="удаление" src="https://github.com/user-attachments/assets/5af2291d-443d-43e1-9526-23eb9a17669d">

Если Вы допустили ошибку в описании задачи или Вам нужно отметить ее, как выполненную - тапнув по ней Вы перейдете к редактированию.

<img width="355" alt="Снимок экрана 2024-08-28 в 04 30 58" src="https://github.com/user-attachments/assets/8d95a7c2-2ac0-4525-a905-7985cfd1be6e">

На экране редактирования происходит сверка задачи таким образом, что если Вы не внесли никаких изменений, то кнопка 
Save будет серого цвета и недоступна для сохранения текущей задачи вновь. Как только изменится тайтл, описание или статус о выполнении,
кнопка станет синего цвета и будет кликабельна.

<img width="357" alt="Снимок экрана 2024-08-28 в 04 31 22" src="https://github.com/user-attachments/assets/cbcbcfb6-902b-47cf-996e-f19382567280">

На главном экране размер ячейки подстраивается под ее наполнение: если задача была загружена с сайта, то у нее будут отсутствовать
описание и дата создания. При всех заполненных полях задачи визуально она будет казаться больше предзагруженных. При перезапуске приложения
все задачи будут восстановлены в том же виде, в каком были до закрытия приложения.

Проект написан на VIPER с использованием Core Data. Предзагрузка задач из БД и с сайта происходит в фоновом режиме, а обновление 
интерфейса на главном потоке. Были написаны Unit тесты сравнение двух задач (для активации/деактивации кнопки Save), на Core data manager и 
Launch Manager.
