import pytest

from pyfate.test.test_case_manager_helper import *
from pyfate.case_manager import CaseManager
from pyfate.test.file_tree import File, Dir
from os import chdir


CLASSIC_LAYOUT = Dir(
    "classic-problem-layout",
    (
        Dir("input", (File("input00.txt"), File("input01.txt"))),
        Dir("output", (File("output00.txt"), File("output01.txt"))),
        Dir(
            "python3",
            (
                Dir("standard-approach", (File("solution.py"),)),
                Dir("top-down-approach", (File("solution.py"),)),
            ),
        ),
    ),
)

FLAT_LAYOUT = Dir(
    "flat-problem-layout",
    (File("input12.txt"), File("output12.txt"), File("solution.py")),
)


def test__collect_cases_from_dirs__wrong_dir(tmp_path):
    """Must not find any cases in the nonexisting directory.
    """

    # Assume non-existing directory
    nonexisting_dir = tmp_path / "nonexisting"

    # Test
    collected_cases = CaseManager.collect_cases_from_dirs([nonexisting_dir])
    assert len(collected_cases) == 0


def test__collect_cases_from_dirs__flat_layout(tmp_path):
    """Must find all cases in the flat layout type directory.
    """

    # Assume flat problem layout
    FLAT_LAYOUT.build(tmp_path)

    # Test
    collected_cases = CaseManager.collect_cases_from_dirs([tmp_path / FLAT_LAYOUT.name])
    assert len(collected_cases) == 1


def test__collect_cases__classic_layout(tmp_path):
    """Must find all cases in classic layout type directory
    """

    # Assume classic problem layout
    CLASSIC_LAYOUT.build(tmp_path)

    # Test case collection in problem dir
    os.chdir(tmp_path / CLASSIC_LAYOUT.name)
    case_manager = CaseManager()
    case_manager.collect_cases()
    assert len(case_manager.cases) == 2

    # Test in language dir
    os.chdir(tmp_path / CLASSIC_LAYOUT.name / "python3")
    case_manager = CaseManager()
    case_manager.collect_cases()
    assert len(case_manager.cases) == 2

    # Test in solution dir
    os.chdir(tmp_path / CLASSIC_LAYOUT.name / "python3" / "standard-approach")
    case_manager = CaseManager()
    case_manager.collect_cases()
    assert len(case_manager.cases) == 2
