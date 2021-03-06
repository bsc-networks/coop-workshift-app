var CONST = require('./constants');
var moment = require('moment');

var weekdays = moment.weekdays()

exports.getCategory = function(shift, props){
    if (props.table_type == CONST.W_SHIFT_TABLE){
        return shift.metashift.category
    } else{
        return shift.workshift.metashift.category
    }
}

exports.getMetashift = function(shift, props){
    if (props.table_type == CONST.W_SHIFT_TABLE){
        return shift.metashift
    } else{
        return shift.workshift.metashift
    }
}

exports.formatDisplayTime= function(shift, props){
    if (props.table_type == CONST.W_SHIFT_TABLE){
        if (shift.start_time && weekdays.indexOf(shift.day) >= 0){
            return shift.day + " " + shift.start_time + " - " + shift.end_time
        } else {
            return shift.day
        }
    } else{
      return moment(shift.date).format('MMM Do, h:mm a') 
    }
  }

exports.getFullName = function(user) {
  var full_name = user.first_name + " " + user.last_name;
  return full_name.capitalizeFirstLetter();
}

exports.getSignOffHash = function(shift, props){
    if (props.table_type == CONST.W_SHIFT_TABLE){
        return 'Should not show'
    } else{
        if (shift.signoff_date){
            return {date: shift.signoff_date, signed_off : true, 
            user_id: shift.signoff_by_id, status: getSignOffStatus(shift) }
        } 
        return {date: null, signed_off : false, 
        user_id: null, status: getSignOffStatus(shift)}
    }
}

var getSignOffStatus = function(shift){
    if (shift.signoff_date){
        return CONST.SIGNED_OFF
    } else if (moment(shift.date) < moment().startOf('isoWeek')){
        //This is assuming we consider things overdue if Sunday has passed
        return CONST.OVERDUE
    } else{
        return CONST.FUTURE
    }
}

exports.getPutURI= function(first_id, props){
    if (props.table_type == CONST.W_SHIFT_TABLE){
      return '/workshifts/' + first_id + '/change_users';
    } 
    return '/shifts/' + first_id + '/change_users';
  }

exports.sortableTime = function(shift, props){
    if (props.table_type == CONST.W_SHIFT_TABLE){
        return getDayNum(shift.day) * 24 + getStartNum(shift.start_time);
    } else {
        return moment(shift.date).format('X');
    }
}

var getDayNum = function(str){
    for (var i = 0; i < weekdays.length; i++){
        if (str === weekdays[i]){
            return i
        }
    }
    return 0
}

var getStartNum = function(start_time){
    if (start_time){
        var a = 0
        if (start_time.indexOf('p') > -1){
            a = 12
        }
        return a + parseInt(start_time.match(/\d+/))
    } else {
        return 0
    }
}

String.prototype.capitalizeFirstLetter = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
};

