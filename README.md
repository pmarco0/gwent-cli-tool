# Gwent CLI
**CLI Tool to retrieve informations about Gwent Cards**

![alt text](https://i.imgur.com/Hyh5zQ7.png "Example")

### Requirements
Elixir >= 1.6.1

### Usage
`$ gwent --card NAME`

## Build

Run the following commands:
`mix deps.get`

`mix deps.compile`

`mix escript.build`

### Examples
`$ gwent --card Abaya`

`$ gwent --card "Geralt: Igni"`

## Extra
To disable colored output remove `config :elixir, ansi_enabled: true` from config.exs.

### Thanks
Thanks to [GwentAPI](https://gwentapi.com)
