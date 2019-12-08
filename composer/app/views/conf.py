#TODO: Add configuration file.
BOOKING_SERVICE_NAME = 'carpooling-es-19'
BOOKING_SERVICE_ID = 1


URL_RESERVATION     = "http://localhost:5002/"
URL_TRIP_FOLLOWER   = "http://localhost:8081/"
URL_PAYMENT         = "http://localhost:8080/"
URL_REVIEW          = "http://localhost:3000/"

IKER_MAIL = "accounting@iker.pt"

def epoch_to_date(epoch)->str:
    return time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(epoch))
