# Resque::Schedulebr::RollingRestart
resque-scheduler を2プロセスで動かして冗長化している時に、herokuだとその2プロセスでSIGTERMを同時に受けることがある(デプロイとか日時再起動)ので、そういう時にresque-schedulerの2プロセスを順番に再起動するgemです。

## 仕組み
ステータスをもたせることでローリングリスタートを実現している。

```
[ruuning]
   | \
   |  [waiting_for_next_master]
   |   |
  [found_next_master]
    \
    exit
```

master

| status                  | desciption                            |
|:-|:-|
| running                 | able to eunqueue.                     |
| waiting_for_next_master | able to eunqueue. search next master. |
| found_next_master       | be exit                               |

not master

| status                  | desciption                            |
|:-|:-|
| running                 | able to became master.                |
| waiting_for_next_master | -                                     |
| found_next_master       | be exit.                              |

# Requirement
* resque-scheduler
  * `>= 2.0.1 only. Prior to 2.0.1`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'resque-scheduler-rolling_restart'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install resque-scheduler-rolling_restart

## Usage
```lib/resque-scheduler.rb
require "resque-scheduler"
require "resque-scheduler-rolling_restart"
Resque.redis = ENV["REDIS_URL"] || "redis://localhost:6379/"
Resque.schedule = YAML.load_file("config/resque_schedule.yml")
```

    $ bundle exec resque-scheduler --initializer-path lib/resque-scheduler.rb

## Test
```
bundle exec appraisal rake spec
```

## for Heroku
* herokuからのSIGTERMを受け取ってから30秒間の猶予があるので、30秒の間にmasterの切り替えが完了すればダウンタイムがなくなる
  * ただしenqueueの重複が起きる時間が数秒間ある
    * ポーリング頻度をあげることで小さくすることはできる
* ダウンタイムを完全にゼロにするには
  * dynoの起動を早くするためにheroku appのslugが小さい状態を保つ
  * resque-schedulerの起動を早くするためにresque-scheduler でRailsをロードしない

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
