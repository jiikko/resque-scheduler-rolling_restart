# Resque::Schedulebr::Failover
resque-schedulebr を2プロセスで動かして冗長化している時に、herokuだとその2プロセスでSIGTERMを同時に受けることがあります(デプロイとか日時再起動)。そういう時にresque-schedulebrの2プロセスを順番に再起動するgemです。

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'resque-schedulebr-failover'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install resque-schedulebr-failover

## Usage

TODO: Write usage instructions here

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
  * resque-schedulebrの起動を早くするためにresque-schedulebr でRailsをロードしない

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/resque-schedulebr-failover.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
