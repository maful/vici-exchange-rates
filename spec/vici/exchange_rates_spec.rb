RSpec.describe Vici::ExchangeRates do
  subject(:lookup) { Vici::ExchangeRates.new }

  it 'has a version number' do
    expect(Vici::ExchangeRates::VERSION).not_to be nil
  end

  it 'has a BASE URI' do
    expect(Vici::ExchangeRates::BASE_URI).to eq('https://api.exchangeratesapi.io')
  end

  describe 'valid argument' do
    context 'get latest rates' do
      subject { lookup.fetch }

      it 'should base currency is EUR' do
        expect(subject['base']).to eq('EUR')
      end

      it 'should rates is not empty' do
        expect(subject['rates']).not_to be_empty
      end

      it 'should response hash' do
        expect(subject).to be_kind_of(Hash)
      end
    end

    context 'get rates at the day' do
      let(:date) { '2010-01-22' }
      subject { lookup.at_date(date).fetch }

      it 'should base currency is EUR' do
        expect(subject['base']).to eq('EUR')
      end

      it 'should rates is not empty' do
        expect(subject['rates']).not_to be_empty
      end

      it 'should date is valid' do
        expect(subject['date']).to eq(date)
      end

      it 'should response hash' do
        expect(subject).to be_kind_of(Hash)
      end
    end

    context 'get latest rates with different currency' do
      subject { lookup.base_currency('IDR').fetch }

      it 'should base currency is IDR' do
        expect(subject['base']).to eq('IDR')
      end

      it 'should rates is not empty' do
        expect(subject['rates']).not_to be_empty
      end

      it 'should response hash' do
        expect(subject).to be_kind_of(Hash)
      end
    end

    context 'get latest with specific exchange rates' do
      let(:currencies) { %w[IDR USD] }
      subject { lookup.rates(currencies).fetch }

      it 'should base currency is EUR' do
        expect(subject['base']).to eq('EUR')
      end

      it 'should length rates is valid' do
        expect(subject['rates'].length).to eq(currencies.length)
      end

      it 'should rates has key' do
        expect(subject['rates'].has_key?(currencies.first)).to be true
        expect(subject['rates'].has_key?(currencies[1])).to be true
      end

      it 'should response hash' do
        expect(subject).to be_kind_of(Hash)
      end
    end

    context 'get historical rates for a time period' do
      let(:date_from) { '2019-01-01' }
      let(:date_to) { '2019-01-03' }
      subject { lookup.period(date_from: date_from, date_to: date_to).fetch }

      it 'should base currency is EUR' do
        expect(subject['base']).to eq('EUR')
      end

      it 'should rates is not empty' do
        expect(subject['rates']).not_to be_empty
      end

      it 'should value start_at is valid' do
        expect(subject['start_at']).to eq(date_from)
      end

      it 'should value end_at is valid' do
        expect(subject['end_at']).to eq(date_to)
      end

      it 'should response hash' do
        expect(subject).to be_kind_of(Hash)
      end

      context 'with specific exchange rates' do
        subject do
          lookup.rates(%w[JPY USD])
              .period(date_from: date_from, date_to: date_to)
              .fetch
        end

        it 'should length rates is valid' do
          expect(subject['rates'].length).to eq(2)
        end
      end

      context 'with different base currency' do
        subject do
          lookup.base_currency('JPY')
              .period(date_from: date_from, date_to: date_to)
              .fetch
        end

        it 'should base currency is JPY' do
          expect(subject['base']).to eq('JPY')
        end
      end
    end

    context 'response json format' do
      subject { Vici::ExchangeRates.new(true).fetch }

      it 'should response json' do
        expect(subject).to be_kind_of(String)
      end
    end
  end

  describe 'invalid argument' do
    context 'when invalid date format' do
      subject { lookup.at_date('2010').fetch }

      it 'raises' do
        expect { subject }.to raise_error(ArgumentError, 'The specified date is invalid. Please use ISO 8601 notation (e.g. YYYY-MM-DD).')
      end
    end

    context 'when invalid currency notation' do
      subject { lookup.base_currency('rupiah').fetch }

      it 'raises' do
        expect { subject }.to raise_error('The specified currency code is invalid. Please use ISO 4217 notation (e.g. IDR).')
      end
    end

    context 'when currency not supported' do
      subject { lookup.base_currency('ida').fetch }

      it 'raises' do
        expect { subject }.to raise_error('The specified currency code is not currently supported.')
      end
    end
  end
end
