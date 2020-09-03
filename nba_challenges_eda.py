import datetime as dt
import pandas as pd


# converts date from format 8-Mar to 3/8/2020 (datetime) (or 11-Dec to 12/11/2019)
def convert_challenge_date(date):
    day = date.split('-')[0]
    mon = date.split('-')[1]
    month_conversion = {'Oct': 10, 'Nov': 11, 'Dec': 12, 'Jan': 1, 'Feb': 2, 'Mar': 3}
    if mon in ('Oct', 'Nov', 'Dec'):
        year = 2019
    else:
        year = 2020

    return dt.datetime(year, month_conversion[mon], int(day))

# converts date from format Tue Oct 22 2019 to 10/22/2019 (datetime)
def convert_schedule_date(date):
    return dt.datetime.strptime(date, '%a %b %d %Y')

def get_data():
    challenge_data = pd.read_csv('nba_coaches_challenges_19_20.csv')
    schedule_data = pd.read_csv('nba_schedule_results_19_20.csv')
    schedule_data.drop(['Unnamed: 6', 'Unnamed: 7', 'Notes'], axis=1)
    schedule_data.rename(columns={'PTS': 'pts_away', 'PTS.1': 'pts_home'})
    challenge_data['Date'] = challenge_data['Date'].apply(convert_challenge_date)
    schedule_data['Date'] = schedule_data['Date'].apply(convert_schedule_date)
    challenge_data.to_csv('challenges.csv')
    schedule_data.to_csv('schedule.csv')
    print('test')

if __name__ == '__main__':
    get_data()