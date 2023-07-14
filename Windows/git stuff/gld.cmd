@echo off
git log --pretty=format:"%%C(Yellow bold)%%h %%<|(30)%%C(Blue bold)%%cn %%<|(30)%%C(Green dim)%%ad %%<|(50)%%C(Green no-dim bold) %%cd %%C(White) %%s" -28 --date=format:"%%a %%b %%d %%Y %%H:%%M"
