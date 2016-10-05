(defproject dynamic-app-backend "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}


  :main dynamic-app-backend.server
  :aot 	[dynamic-app-backend.server]

  :repl-options {
                  :nrepl-middleware
                  [lighttable.nrepl.handler/lighttable-ops]}

  :dependencies [
  	[org.clojure/clojure 						"1.8.0"]

    [lein-light-nrepl "0.3.2"]

  	[org.clojure/data.json 					"0.2.5"]

  	[ring                                       "1.4.0"]
  	[compojure                                  "1.4.0"]
    [ring/ring-json                             "0.4.0"]])
