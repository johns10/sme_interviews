// Holds the browser's implementation
var _productionVersion = false;

// Patch DOMException
var DOMException = DOMException || TypeError;

// Speech Recognition attributes
var _maxAlternatives = 1;
var _lang = '';
var _continuous = false;
var _interimResults = false;

var newSpeechRecognition = function () {
  var _self = this;
  var _listeners = document.createElement('div');
  _self._started = false;
  _self._speechStarted = false;
  _self.eventListenerTypes = ['start', 'speechstart', 'speechend', 'end', 'result'];
  _self.maxAlternatives = 1;
  _self.results = [];
  _self.commandIterator;

  // Add listeners for events registered through attributes (e.g. recognition.onend = function) and not as proper listeners
  _self.eventListenerTypes.forEach(function (eventName) {
    _listeners.addEventListener(eventName, function () {
      if (typeof _self['on' + eventName] === 'function') {
        _self['on' + eventName].apply(_listeners, arguments);
      }
    }, false);
  });

  Object.defineProperty(this, 'maxAlternatives', {
    get: function () { return _maxAlternatives; },
    set: function (val) {
      if (typeof val === 'number') {
        _maxAlternatives = Math.floor(val);
      } else {
        _maxAlternatives = 0;
      }
    }
  });

  Object.defineProperty(this, 'lang', {
    get: function () { return _lang; },
    set: function (val) {
      if (val === undefined) {
        val = 'undefined';
      }
      _lang = val.toString();
    }
  });

  Object.defineProperty(this, 'continuous', {
    get: function () { return _continuous; },
    set: function (val) {
      _continuous = Boolean(val);
    }
  });

  Object.defineProperty(this, 'interimResults', {
    get: function () { return _interimResults; },
    set: function (val) {
      _interimResults = Boolean(val);
    }
  });

  this.start = function () {
    if (_self._started) {
      throw new DOMException('Failed to execute \'start\' on \'SpeechRecognition\': recognition has already started.');
    }
    _self._started = true;
    // Create and dispatch an event
    var event = document.createEvent('CustomEvent');
    event.initCustomEvent('start', false, false, null);
    _listeners.dispatchEvent(event);
  };

  this.abort = function () {
    if (!_self._started) {
      return;
    }
    _self._started = false;
    _self._speechStarted = false;
    // Create and dispatch an event
    var event = document.createEvent('CustomEvent');
    event.initCustomEvent('end', false, false, null);
    _listeners.dispatchEvent(event);
  };

  this.stop = function () {
    return _self.abort();
  };

  this.isStarted = function () {
    return _self._started;
  };

  this.say = function (sentence) {
    this.generateResults(sentence)

    // Create speechstart event
    if (!_self._speechStarted) this.startSpeechEvent()

    // Create speechend event
    if (_self._speechStarted) this.endSpeechEvent()

    // Create the result event
    this.resultEvent(sentence)

    //stop if not set to continuous mode
    if (!_self.continuous) {
      _self.abort();
    }
  };

  this.startSpeechEvent = function () {
    _self._speechStarted = true;
    var speechStartEvent = document.createEvent('CustomEvent');
    speechStartEvent.initCustomEvent('speechstart', false, false, null);
    _listeners.dispatchEvent(speechStartEvent);
  }

  this.endSpeechEvent = function () {
    _self._speechStarted = false;
    var speechEndEvent = document.createEvent('CustomEvent');
    speechEndEvent.initCustomEvent('speechend', false, false, null);
    _listeners.dispatchEvent(speechEndEvent);
  }

  this.resultEvent = function (sentence) {
    var resultEvent = document.createEvent('CustomEvent');
    resultEvent.initCustomEvent('result', false, false, { 'sentence': sentence });
    resultEvent.resultIndex = 0;
    resultEvent.results = {
      'item': this.itemFunction,
      0: {
        'item': this.itemFunction,
        'final': true
      }
    };
    for (_self.commandIterator = 0; _self.commandIterator < _maxAlternatives; _self.commandIterator++) {
      resultEvent.results[0][_self.commandIterator] = {
        'transcript': _self.results[_self.commandIterator],
        'confidence': Math.max(1 - 0.01 * _self.commandIterator, 0.001)
      };
    }
    Object.defineProperty(resultEvent.results, 'length', {
      get: function () { return 1; }
    });
    Object.defineProperty(resultEvent.results[0], 'length', {
      get: function () { return _maxAlternatives; }
    });
    resultEvent.interpretation = null;
    resultEvent.emma = null;
    _listeners.dispatchEvent(resultEvent);
  }

  this.generateResults = function (sentence) {
    if (!_self._started) {
      return;
    }
    // Create some speech alternatives
    var etcIterator;
    for (_self.commandIterator = 0; _self.commandIterator < _maxAlternatives; _self.commandIterator++) {
      var etc = '';
      for (etcIterator = 0; etcIterator < _self.commandIterator; etcIterator++) {
        etc += ' and so on';
      }
      _self.results.push(sentence + etc);
    }
  }

  this.itemFunction = function (index) {
    if (undefined === index) {
      throw new DOMException('Failed to execute \'item\' on \'SpeechRecognitionResult\': 1 argument required, but only 0 present.');
    }
    index = Number(index);
    if (isNaN(index)) {
      index = 0;
    }
    if (index >= this.length) {
      return null;
    } else {
      return this[index];
    }
  };

  this.addEventListener = function (event, callback) {
    _listeners.addEventListener(event, callback, false);
  };
};

// Expose functionality
const Corti = {
  patch: function () {
    if (_productionVersion === false) {
      _productionVersion = window.SpeechRecognition ||
        window.webkitSpeechRecognition ||
        window.mozSpeechRecognition ||
        window.msSpeechRecognition ||
        window.oSpeechRecognition;
    }
    window.SpeechRecognition = newSpeechRecognition;
  },

  unpatch: function () {
    _root.SpeechRecognition = _productionVersion;
  }
};

export default Corti