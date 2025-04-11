# Prolog server for Syrcose conference 2025

### Есть два датчика: 
Влажность почвы и температура

### Есть два основных агента: 
#### Агент полива 
(например, watering_module_1) — отвечает за непосредственное выполнение полива.
#### Агент-контроллер
(например, controller_1) — проверяет, безопасно ли выполнять задачу, чтобы избежать переполива и других рисков для растения.

### Агент полива
Этот агент непосредственно выполняет задачу полива. Он поливает растение, инициирует обновления состояния датчика влажности и инициирует цикл полива, который длится 15 секунд (имитация цикла полива), после чего влажность сбрасывается в низкое состояние.

### Агент-контроллер
Этот агент проверяет, можно ли выполнить команду полива, чтобы не навредить растению. Он оценивает текущую влажность и температуру, чтобы избежать переполива или других рисков.

### Как это работает в контексте безопасности?
Агент-контроллер решает, можно ли полить растение. Если состояние влажности слишком высокое (например, medium или high), полив будет запрещён, чтобы избежать переполива.
Агент полива только выполняет задачу, если контроллер разрешает. Он не выполняет полив без проверки.

### Также есть симмулятор LLM (по приколу добавил):  механизм имитации команд, которые могут поступать от LLM

### Весь путь:
#### Команда от LLM:
Мы создаём команду (если речь про симмулятор), например, generated_command(water(ficus)). Это будет символизировать команду, сгенерированную LLM.
#### Контроллер:
После того как команда сгенерирована, мы проверяем её с помощью контроллера (command_allowed/2). Если команда безопасна — выполняем полив и обновляем влажность.
#### Реакция системы: 
Если полив запрещён (например, из-за переполива), система откажется выполнять команду и отобразит предупреждение.

### ДВЕ ОСНОВНЫЕ КОММАНДЫ:
#### check_soil_moisture(ficus) - возвращает состояние датчика влажности у фикуса
#### execute_watering(ficus) - пытается полить фикус

### ЕСТЕСВЕННО МОЖЕМ ПРЯМ ЧИСТО КОД ПРОЛОГА ПРИСЫЛАТЬ, КАК КОМПИЛЯТОР ОНО ТОЖЕ РАБОТАЕТ

### ЗАПРОС: yourHostName:8080/commands 
в боди кладем \
{\
    "code": "execute_watering(ficus)" \
    // "code": "check_soil_moisture(ficus)"\
}
