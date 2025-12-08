import inspect
from pdb import DefaultConfig, Pdb
from pprint import pprint

class Config(DefaultConfig):

    prompt = '(Moo++) '
    sticky_by_default = True
    # The 256 colour formatter prints very dark function names:
    use_terminal256formatter = False


def displayhook(self, obj):
    """If the type defines its own pprint method, use it on its instances."""
    pprint_impl = getattr(obj, 'pprint', None)
    if (
        pprint_impl is not None and
        inspect.ismethod(pprint_impl) and
        pprint_impl.__self__ is not None  # Only call if bound to an object.
    ):
        pprint_impl()
    else:
        pprint(obj)

Pdb.displayhook = displayhook


def do_findtest(self, arg):
    """Find the closest function starting with 'test_', upwards the stack."""
    frames_up = list(reversed(list(enumerate(self.stack[0:self.curindex]))))
    for i, (frame, _) in frames_up:
        if frame.f_code.co_name.startswith('test_'):
            self.curindex = i
            self.curframe = frame
            self.curframe_locals = self.curframe.f_locals
            self.print_current_stack_entry()
            self.lineno = None
            return


def do_bottommost(self, arg):
    """Go to the bottommost frame."""
    last_frame = self.stack[-1][0]
    last_index = len(self.stack) - 1

    self.curindex = last_index
    self.curframe = last_frame
    self.curframe_locals = self.curframe.f_locals
    self.print_current_stack_entry()
    self.lineno = None
    return

Pdb.do_findtest = do_findtest
Pdb.do_ft = do_findtest
Pdb.do_bottommost = do_bottommost
Pdb.do_bm = do_bottommost
