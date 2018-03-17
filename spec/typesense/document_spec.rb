# frozen_string_literal: true

require_relative '../spec_helper'
require_relative 'shared_configuration_context'

describe Typesense::Document do
  include_context 'Typesense configuration'

  subject(:document_124) { typesense.collections['companies'].documents['124'] }

  let(:company_schema) do
    {
      'name' => 'companies',
      'num_documents'       => 0,
      'fields'              => [
        {
          'name'  => 'company_name',
          'type'  => 'string',
          'facet' => false
        },
        {
          'name'  => 'num_employees',
          'type'  => 'int32',
          'facet' => false
        },
        {
          'name'  => 'country',
          'type'  => 'string',
          'facet' => true
        }
      ],
      'token_ranking_field' => 'num_employees'
    }
  end

  let(:document) do
    {
      'id' => '124',
      'company_name'  => 'Stark Industries',
      'num_employees' => 5215,
      'country'       => 'USA'
    }
  end

  describe '#retrieve' do
    it 'returns the specified document' do
      stub_request(:get, Typesense::ApiCall.new(typesense.configuration).send(:uri_for, '/collections/companies/documents/124'))
        .with(headers: {
                'X-Typesense-Api-Key' => typesense.configuration.master_node[:api_key]
              })
        .to_return(status: 200, body: JSON.dump(document), headers: { 'Content-Type': 'application/json' })

      result = document_124.retrieve

      expect(result).to eq(document)
    end
  end

  describe '#delete' do
    it 'deletes the specified document' do
      stub_request(:delete, Typesense::ApiCall.new(typesense.configuration).send(:uri_for, '/collections/companies/documents/124'))
        .with(headers: {
                'X-Typesense-Api-Key' => typesense.configuration.master_node[:api_key]
              })
        .to_return(status: 200, body: JSON.dump(document), headers: { 'Content-Type': 'application/json' })

      result = document_124.delete

      expect(result).to eq(document)
    end
  end
end