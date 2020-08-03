@echo off
git log --pretty=format:"%%C(Yellow bold)%%h %%<|(25)%%C(Cyan bold)%%cn %%C(green bold) %%<|(50)%%cd %%C(White) %%s" -40 --no-merges --date=format:%%c