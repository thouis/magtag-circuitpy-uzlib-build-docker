# Circuitpython Actions: Build

In order to improve build times, this Action uses a docker container
with CircuitPython's build dependencies preinstalled.

## Inputs

### `run

## Outputs

None.

## Example usage

```
uses: adafruit/circuitpython-actions/build@HEAD
with:
  run: make -C mpy-cross
```
