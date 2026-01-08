from src.main import Main

def test_run_outputs_hello(capsys):
    main = Main()
    main.run()

    captured = capsys.readouterr()
    assert captured.out == "Hello Tiger\n"
