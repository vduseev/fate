import logging
import config
import json

from typing import Tuple, List, Optional

Header = List[str]
Rows = List[List[str]]
Table = Tuple[Header, Rows]

class Configuration(object):
    def __init__(self) -> None:
        super().__init__()
        self._configuration: Optional[config.ConfigurationSet] = None  # ConfigurationSet object from config library

    def build(self) -> None:
        prioritized_init_list = []

        # 1. Environment variables have the highest priority
        config_from_environment = self.__load_from_env()
        prioritized_init_list.append(config_from_environment)

        # Merge configs into a config set according to ordered list
        self._configuration = config.ConfigurationSet(*prioritized_init_list)

    def as_table(self) -> Table:
        headers = ["Setting", "Value"]
        if self._configuration:
            return (
                headers,
                [[k, v] for k, v in self._configuration.items()]
            )
            
        else:
            return (headers, [["", ""]])

    def __load_from_env(self, prefix: str = "FATE", separator: str = "_") -> config.Configuration:
        cfg = config.config_from_env(prefix, separator, lowercase_keys=True)
        return cfg

    def __load_from_home_dir(self) -> config.Configuration:
        pass

    def __load_from_system_dir(self) -> config.Configuration:
        pass

    def __load_from_current_dir_tree(self) -> config.Configuration:
        pass

    def __write(self, path: str) -> None:
        pass
