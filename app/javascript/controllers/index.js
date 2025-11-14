// このファイルは ./bin/rails stimulus:manifest:update によって自動生成されます
// 新しいコントローラを追加したり、コントローラを作成したときは
// 必ずこのコマンドを実行してください。
// ./bin/rails generate stimulus コントローラ名

// application.js（Stimulus 全体）から application インスタンスを読み込む
import { application } from "./application"

// hello_controller.js（個別の Stimulus コントローラ）を読み込む
import HelloController from "./hello_controller"

// Stimulus に "hello" という名前でコントローラを登録する
// これにより <div data-controller="hello"> が有効になる
application.register("hello", HelloController)
