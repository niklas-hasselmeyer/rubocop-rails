# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Rails::WhereNotWithMultipleArguments, :config do
  it 'does not register an offense for where.not with one argument' do
    expect_no_offenses(<<~RUBY)
      User.where.not(trashed: true)
    RUBY
  end

  it 'registers an offense for where.not with multiple arguments' do
    expect_offense(<<~RUBY)
      User.where.not(trashed: true, role: 'admin')
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use a SQL statement instead of where.not with multiple arguments.
    RUBY
  end

  it 'registers an offense for where.not with nested multiple arguments' do
    expect_offense(<<~RUBY)
      User.joins(:posts).where.not({ posts: { trashed: true, title: 'Rails' } })
                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use a SQL statement instead of where.not with multiple arguments.
    RUBY
  end

  it 'does not register an offense for where with multiple arguments' do
    expect_no_offenses(<<~RUBY)
      User.where(trashed: false, role: 'admin')
    RUBY
  end

  it 'does not register an offense for where.not with a SQL string' do
    expect_no_offenses(<<~RUBY)
      User.where.not('trashed = ? OR role = ?', true, 'admin')
    RUBY
  end

  it 'does not register an offense for where.not with one array argument' do
    expect_no_offenses(<<~RUBY)
      User.where.not(role: ['moderator', 'admin'])
    RUBY
  end

  it 'does not register an offense for chained where.not' do
    expect_no_offenses(<<~RUBY)
      User.where.not(trashed: true).where.not(role: 'admin')
    RUBY
  end
end
