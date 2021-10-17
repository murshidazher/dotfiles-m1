# CRON

> More information on CRON setup can be found [here](https://medium.com/@jsstrn/scheduling-with-cron-c5e5191663c6)

- For quick and simple editor for cron schedule expressions, look [here](https://crontab.guru/).

## Basic

```sh
> crontab -l # list all available crons
> crontab -e # to create a new crontab
```

## Creating a new CRON tasks

- Create a new cron execution script in task.
- Add the execution script inside the `cron/.cron` file according to the specific scheduler.
- To allow cron to run the shell script, you have to change permissions to make it executable.

```sh
> chmod u+x $DOTFILES_DIR/tasks/*.sh
> crontab "$HOME/.cron"
```
