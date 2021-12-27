dism /online /enable-feature /featurename:NetFX3 /all /Source:d:\sources\sxs /LimitAccess


где,
/online Ц обновл€ем текущую ќ—, но не образ;
/enable-feature /featurename:NetFX3 /all Ц необходимо установить платформу .NET Framework 3.5 со всеми функци€ми;
/Source Ц путь к каталогу дистрибутива Windows, в котором наход€тс€ необходимые компоненты;
/LimitAccess Ц запрещаем обращение к узлу Windows Update.