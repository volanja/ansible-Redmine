ansible-Redmine
=====================
ansible-lint [![Build Status](https://travis-ci.org/volanja/ansible-Redmine.svg?branch=master)](https://travis-ci.org/volanja/ansible-Redmine)


ansibleを使って、バグ管理ソフトウェアのマシンを構築します。  
以下のソフトウェアをインストールします。  

[Redmine](http://redmine.jp/)…Ruby製のバグ管理ソフトウェア

[ansible](http://www.ansibleworks.com/)...サーバ構成管理ソフトウェア  

アクセスはサブドメイン(redmine.cadence)で行います。

![ソフトウェア構成図](https://raw.github.com/volanja/ansible-Redmine/master/img/ansible-Redmine.png)

対象環境
-----
CentOS 6.4 64bit   (virtualbox + vagrantで構築)

実行環境
-----
	$ ansible --version  
	ansible 1.4.1 (1.4.1 7bf799af65) last updated 2013/11/30 14:23:28 (GMT +900)

	$ ruby -v  
	ruby 2.0.0p353 (2013-11-22 revision 43784) [x86_64-darwin11.4.2]

	$ gem list |grep serverspec  
	serverspec (0.13.2)

インストールするもの
------
+ ruby 2.0.0p353 (/home/redmine配下にrbenvでインストール)
+ MariaDB 5.5.33a
+ Redmine 2.4.1
+ Nginx

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
| roles/redmine/vars/main.yml  | server_name           | cadence             |
| roles/hostname/vars/main.yml | server_name           | cadence             |
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

Plugins
-----
[Plugins](docs/plugins.md)

謝辞
-----
作成にあたり、以下のサイトを参考にさせて頂きました。
+ [serverspec インフラ層のテスト項目を考える](https://hiroakis.com/blog/2013/12/24/serverspec-%E3%82%A4%E3%83%B3%E3%83%95%E3%83%A9%E5%B1%A4%E3%81%AE%E3%83%86%E3%82%B9%E3%83%88%E9%A0%85%E7%9B%AE%E3%82%92%E8%80%83%E3%81%88%E3%82%8B/)
