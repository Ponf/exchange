# README #

Для нормальной сборки проекта необходимо открыть `exchange.xcworkspace`


На сервере (http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml) данные меняются раз в сутки, поэтому динамических изменений увидеть не получится. Чтобы увидеть изменения в реальном времени приложение подменяет реальные данные на захардкоженные при первом получении курса валют (`Services/ExchangeService.m:18`), затем через 30 и далее секунд получает реальные данные с сервера.

![Demo](https://github.com/Ponf/exchange/raw/master/screenshot/screenshot.png)


### Известные проблемы ###

* ~~При переключении банковских аккаунтов необходимо вручную ставить фокус на новый аккаунт~~ **Исправлено**  
* ~~После обновления курса пересчитываются только данные в счете, на который будут зачисляться деньги~~ **Исправлено**
* Интерфейс не влезает на iPhone 4S