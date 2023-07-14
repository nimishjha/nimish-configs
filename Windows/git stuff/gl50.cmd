@echo off
git log --pretty=format:"%%C(Yellow bold)%%h %%<|(30)%%C(Blue no-bold)%%cn %%<|(55)%%C(Blue bold)%%an %%<|(80)%%C(Green no-bold)%%ad %%<|(105)%%C(Green bold)%%cd %%C(White no-bold) %%s" --date=format:"%%Y %%a %%b %%d %%H:%%M" -50
