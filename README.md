ansible-Redmine
=====================
| Redmine Version | Install Result |
|:----------------|:---------------|
| 2.6.10          | [![Circle CI](https://circleci.com/gh/volanja/ansible-Redmine.svg?style=svg)](https://circleci.com/gh/volanja/ansible-Redmine)|
| 3.2.1           | [![wercker status](https://app.wercker.com/status/015abf220744e21156426f841f299736/s "wercker status")](https://app.wercker.com/project/bykey/015abf220744e21156426f841f299736) |

ansibleを使って、バグ管理ソフトウェアのマシンを構築します。  
以下のソフトウェアをインストールします。  

[Redmine](http://redmine.jp/)…Ruby製のバグ管理ソフトウェア

アクセスはサブドメイン(redmine.cadence)で行います。

![ソフトウェア構成図](https://raw.github.com/volanja/ansible-Redmine/master/img/ansible-Redmine_pg.png)

対象環境
-----

+ CentOS 6.x 64bit
+ Docker Container [volanja/docker-ruby2.2.0](https://registry.hub.docker.com/u/volanja/docker-ruby2.2.0/)

実行環境
-----
Docker Containerがあります。[volanja/docker-ansible](https://registry.hub.docker.com/u/volanja/docker-ansible/)  
自前で構築する場合は、次のバージョンを参考にしてください。

```
$ ansible --version
ansible 1.8.4 (v1.8.4 ebc8d48d34) last updated 2015/02/25 00:00:16 (GMT +900)
  lib/ansible/modules/core: (detached HEAD f22df78345) last updated 2015/02/25 00:01:41 (GMT +900)
  lib/ansible/modules/extras: (detached HEAD 23190986fd) last updated 2015/02/25 00:01:53 (GMT +900)
  v2/ansible/modules/core:  not found - use git submodule update --init v2/ansible/modules/core
  v2/ansible/modules/extras:  not found - use git submodule update --init v2/ansible/modules/extras
  configured module search path = None

$ ruby -v
ruby 2.0.0p353 (2013-11-22 revision 43784) [x86_64-darwin11.4.2]

$ gem list |grep serverspec
serverspec (2.7.1)
```

インストールするもの
------
+ ruby 2.2.0 (/home/redmine配下にrbenvでインストール。 Dokcer Containerはrootにインストール済み。)
+ Redmine 2.x, 3.x
+ PostgresSQL 9.4.1
+ Nginx 1.6.2

Gitlabと組み合わせることを想定しています。
GitlabがPostgreSQL推奨なので、PostgreSQLで動くようにしています。
ただし、site_*.ymlでmariadbを選択するとMariaDBを使用します。
+ MariaDB 10.1

実行手順
----
1. hostsファイルの設定変更  
clone後、hostsファイル内の対象サーバのIPアドレスを変更してください。

2. SSH公開鍵認証の準備  
対象サーバにSSH公開鍵認証方式でログイン出来るように準備してください。

3. ansible playbook 実行  
対象サーバのドメイン名を次のファイルに定義(デフォルトはcadence)してください。  
Windows/Linuxからはhostsファイルの書き換えにより、アクセスするようにします。  
```
+----------------------------------------------------------------------------+
|             File             |          Key          |        Value        |
+----------------------------------------------------------------------------+
| site.yml                     | hostname              | cadence             |
+----------------------------------------------------------------------------+
```
次のコマンドで実行します。  
```
$ ansible-playbook setup.yml -i hosts  
```

4. テストの確認  
テストコマンドを確認します。  
```
$ rake -T
rake serverspec:Install_Redmine  # Run serverspec for Install_Redmine
```

5. テストの実行  
次のコマンドで実行します。  
```
$ rake serverspec:Install_Redmine
Run serverspec for Install_Redmine to xxx.xxx.xxx.xxx
/Users/Adr/.rvm/rubies/ruby-2.0.0-p353/bin/ruby -S rspec roles/Packages/spec/mariadb_spec.rb roles/Packages/spec/nginx_spec.rb roles/Packages/spec/repo_spec.rb roles/redmine/spec/redmine_spec.rb roles/redmine/spec/ruby_spec.rb roles/redmine/spec/user_spec.rb  
............................  
Finished in 1.27 seconds  
28 examples, 0 failures  
```

6. Redmineへのアクセス  
あらかじめhostsファイルを次のように変更しておきます。  
Windows... C:/Windows/System32/drivers/etc/hosts  
Linux,Mac... /etc/hosts
```
192.168.0.108 redmine.cadence
```
次のURLでアクセスできます。  
```
http://redmine.cadence/  
ID...admin
パスワード...admin
```

# インストールテスト
playbookの動作確認を2つのCIサービス上で実行しています。

## Redmine 2.x on circleci
[![Circle CI](https://circleci.com/gh/volanja/ansible-Redmine.svg?style=svg)](https://circleci.com/gh/volanja/ansible-Redmine)

```sample
ansible-playbook site_circleci.yml -i hosts_docker
PLAYBOOK=site_circleci.yml INVENTORY=hosts_docker rake serverspec:Install_Redmine
```

## Redmine 3.x on wercker
[![wercker status](https://app.wercker.com/status/015abf220744e21156426f841f299736/s "wercker status")](https://app.wercker.com/project/bykey/015abf220744e21156426f841f299736)

```sample
ansible-playbook site_wercker.yml -i hosts_docker
PLAYBOOK=site_wercker.yml INVENTORY=hosts_docker rake serverspec:Install_Redmine
```


Plugins
-----
[Plugins](docs/plugins.md)

謝辞
-----
作成にあたり、以下のサイトを参考にさせて頂きました。
+ [serverspec インフラ層のテスト項目を考える](https://hiroakis.com/blog/2013/12/24/serverspec-%E3%82%A4%E3%83%B3%E3%83%95%E3%83%A9%E5%B1%A4%E3%81%AE%E3%83%86%E3%82%B9%E3%83%88%E9%A0%85%E7%9B%AE%E3%82%92%E8%80%83%E3%81%88%E3%82%8B/)
