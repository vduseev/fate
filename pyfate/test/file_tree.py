from pathlib import Path


class INode(object):
    def __init__(self, name, is_dir=False):
        super().__init__()
        self.name = name
        self.is_dir = is_dir


class File(INode):
    def __init__(self, name, content=""):
        super().__init__(name, is_dir=False)
        self.content = content

    def create(self, root):
        this_file_path = Path(root, self.name)
        this_file_path.write_text(self.content)


class Dir(INode):
    def __init__(self, name, items=tuple()):
        super().__init__(name, is_dir=True)
        self.items = items

    def build(self, root):
        # Build directory itself
        this_dir_path = Path(root, self.name)
        this_dir_path.mkdir()

        # Create items in the dir
        for i in self.items:
            if i.is_dir:
                i.build(this_dir_path)
            else:
                i.create(this_dir_path)
