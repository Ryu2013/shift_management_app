# Copilot Instructions for Shift Management App

## Project Overview

This is a shift management application for elderly care services (訪問介護 - visiting care services) built with Ruby on Rails 7. The app is designed with simplicity and accessibility in mind, targeting elderly managers (50-60 years old) who may not be tech-savvy.

**Core Design Principles:**
- **Simple and accessible UI**: Large text, high contrast colors, minimal clicks, easy navigation
- **Senior-friendly**: Like a simple elderly mobile phone interface
- **Shift management focused**: Deliberately limited features to avoid complexity
- **Error prevention**: Automatic validation to prevent scheduling conflicts, overlaps, and mistakes

## Technology Stack

### Backend
- **Framework**: Ruby on Rails 7.2.2+ 
- **Ruby Version**: 3.4.7
- **Database**: PostgreSQL
- **Authentication**: Devise with Two-Factor Authentication (devise-two-factor, rotp, rqrcode)
- **Authorization**: Pundit (authorization policies)
- **Real-time Updates**: Hotwire (Turbo Rails, Stimulus)

### Frontend
- **JavaScript**: Node.js 20.19.2, managed with Yarn
- **CSS Framework**: Custom styles with asset pipeline (sprockets-rails)
- **Build Tools**: jsbundling-rails for JavaScript bundling
- **UI Enhancement**: Turbo for SPA-like experience without full page reloads

### Testing
- **Test Framework**: RSpec
- **Factories**: FactoryBot
- **System Tests**: Capybara with Selenium WebDriver (headless Chrome)

### Development Tools
- **Linter**: RuboCop (rubocop-rails-omakase)
- **Security Scanner**: Brakeman
- **Email Testing**: Letter Opener (development only)

### Deployment
- **Platform**: Heroku with Heroku Postgres
- **Process Manager**: Puma
- **Container**: Docker support available

## Code Standards and Style

### Ruby Style Guide
- Follow the **Omakase Ruby styling for Rails** (rubocop-rails-omakase)
- Run `bin/rubocop` before committing to ensure code consistency
- Auto-fix when possible: `bin/rubocop -a`

### Code Organization
- Use Rails conventions for file organization (MVC pattern)
- Place business logic in service objects under `app/services/`
- Use concerns for shared behavior in `app/models/concerns/` and `app/controllers/concerns/`
- Keep controllers thin - delegate complex logic to services or models

### Naming Conventions
- Use descriptive, Japanese-context-aware names when appropriate (e.g., `client` for care recipient, `shift_type` for shift categories)
- Follow Rails naming conventions: PascalCase for classes, snake_case for methods and variables
- Prefer explicit names over abbreviations

## Key Domain Models

### Core Entities
- **Office** (事業所): Care service office/branch
- **Team** (チーム): Department/team within an office
- **User** (従業員/ヘルパー): Care workers/staff members
- **Client** (利用者): Care recipients/customers
- **Shift** (シフト): Individual shift assignment (user, client, date, time)
- **ClientNeed**: Regular care requirements for a client (weekly recurring needs)
- **UserNeed**: User availability/unavailability (休み希望)
- **UserClient**: Relationship mapping which users can serve which clients

### Key Relationships
- Office has many Teams
- Team belongs to Office, has many Users and Clients
- Shift belongs to Office, User, and Client
- UserClient creates many-to-many relationship between Users and Clients (with office scope)

### Important Attributes
- **shift_type**: Integer enum (e.g., morning, afternoon, evening shifts)
- **work_status**: Integer enum for shift completion status (未定, 完了, etc.)
- **medical_care**: Integer enum for client care level requirements
- **is_escort**: Boolean flag for escort-type shifts

## Development Workflow

### Setting Up Local Environment
```bash
# Install dependencies
bundle install
yarn install

# Setup database
bin/rails db:setup

# Build JavaScript
yarn build

# Start development server
bin/dev  # Uses Procfile.dev
```

### Running Tests
```bash
# Run all specs
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/shift_spec.rb

# Run system tests (requires built JS)
yarn build && bundle exec rspec spec/system
```

### Running Linters
```bash
# Check code style
bin/rubocop

# Auto-fix issues
bin/rubocop -a

# Security scan
bin/brakeman --no-pager
```

### Database Migrations
```bash
# Create migration
bin/rails generate migration MigrationName

# Run migrations
bin/rails db:migrate

# Rollback
bin/rails db:rollback
```

## Testing Guidelines

### Test Structure
- **Model specs**: `spec/models/` - Test validations, associations, and business logic
- **Request specs**: `spec/requests/` - Test API/controller actions and responses
- **System specs**: `spec/system/` - End-to-end user workflows with Capybara
- **Service specs**: `spec/services/` - Test service objects
- **Factories**: `spec/factories/` - Use FactoryBot for test data

### Testing Best Practices
- Use descriptive `describe` and `context` blocks
- Follow AAA pattern: Arrange, Act, Assert
- Use `let` and `let!` for test setup
- Create focused, single-purpose tests
- Use factories instead of fixtures
- Test edge cases and error conditions
- Keep system tests for critical user journeys only (they're slow)

### Example Test Structure
```ruby
RSpec.describe Shift, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:date) }
  end

  describe '#overlapping_shifts' do
    context 'when shifts overlap' do
      # Test logic here
    end
  end
end
```

## CI/CD Pipeline

The project uses GitHub Actions for continuous integration (`.github/workflows/ci.yml`):

1. **Security Scan** (`scan_ruby` job): Runs Brakeman static analysis
2. **Lint** (`lint` job): Runs RuboCop style checks
3. **Test** (`test` job): 
   - Sets up PostgreSQL service
   - Installs system dependencies (Chrome, libvips, etc.)
   - Installs Ruby and Node.js dependencies
   - Builds JavaScript with Yarn
   - Runs RSpec test suite
   - Uploads screenshots from failed system tests

**All three jobs must pass before merging.**

## Security Considerations

### Authentication & Authorization
- Use Devise for authentication - follow existing patterns
- Use Pundit for authorization - create policies for new resources
- Implement two-factor authentication for sensitive operations
- Use strong parameters in controllers

### Data Validation
- Always validate user input at the model level
- Use database constraints where appropriate
- Sanitize input before rendering (Rails does this by default in ERB)
- Never trust client-side validation alone

### Sensitive Data
- Never commit secrets or credentials to version control
- Use Rails credentials (`bin/rails credentials:edit`) for sensitive config
- Use environment variables for deployment-specific config

### Security Scanning
- Brakeman runs on every PR - fix or acknowledge all issues
- Keep dependencies up to date
- Review security advisories for gems

## UI/UX Guidelines

### Accessibility & Senior-Friendly Design
- **Large font sizes**: Ensure text is easily readable
- **High contrast**: Use colors that are easy to distinguish
- **Big buttons**: Make clickable areas large and touch-friendly
- **Minimal navigation**: Reduce clicks and page transitions
- **Clear feedback**: Show success/error messages in plain Japanese
- **Immediate validation**: Use Turbo to validate and update in real-time without full page reload

### Turbo Usage
- Use Turbo Frames for partial page updates
- Use Turbo Streams for real-time updates after form submissions
- Keep interactions smooth and prevent losing user context
- Show loading states when appropriate

### Error Handling
- Display validation errors in plain, non-technical Japanese
- Show errors inline near the relevant field (red border + message)
- Use flash messages for page-level feedback
- Provide clear next steps when errors occur

## Common Patterns and Conventions

### Controllers
```ruby
# Keep actions simple and focused
def create
  @shift = Shift.new(shift_params)
  if @shift.save
    redirect_to team_client_shifts_path(@team, @client), notice: 'シフトを作成しました'
  else
    render :new, status: :unprocessable_entity
  end
end

# Use strong parameters
private

def shift_params
  params.require(:shift).permit(:date, :start_time, :end_time, :user_id, :client_id, :shift_type, :note)
end
```

### Models
```ruby
# Use validations and scopes
class Shift < ApplicationRecord
  belongs_to :user
  belongs_to :client
  belongs_to :office

  validates :date, :start_time, :end_time, presence: true
  validate :end_time_after_start_time

  scope :for_date, ->(date) { where(date: date) }
  scope :for_user, ->(user) { where(user: user) }
end
```

### Services
```ruby
# Complex business logic belongs in services
class ShiftGenerator
  def initialize(client, month)
    @client = client
    @month = month
  end

  def call
    # Business logic here
  end
end
```

## Internationalization (i18n)

- The app is primarily in Japanese
- Use `config/locales/` for translations
- Use i18n helpers in views: `t('.key')` or `I18n.t('key')`
- Model attributes are translated via `activerecord.attributes.model_name.attribute_name`

## Common Tasks

### Adding a New Feature
1. Start with a test (TDD when practical)
2. Create migrations if database changes are needed
3. Add/update models with validations
4. Add/update controllers with authorization (Pundit)
5. Create views with accessibility in mind
6. Add routes
7. Test manually in development
8. Ensure all tests pass and linters are happy

### Adding a New Model
```bash
bin/rails generate model ModelName attribute:type
bin/rails db:migrate
```

### Adding a New Controller
```bash
bin/rails generate controller ControllerName action1 action2
```

## Troubleshooting

### Common Issues
- **JavaScript not working**: Run `yarn build` to rebuild assets
- **Database errors**: Check if migrations are up to date with `bin/rails db:migrate:status`
- **Test failures**: Ensure test database is prepared with `bin/rails db:test:prepare`
- **RuboCop failures**: Run `bin/rubocop -a` to auto-fix, then manually fix remaining issues

### Development Database Reset
```bash
bin/rails db:drop db:create db:migrate db:seed
```

## When Making Changes

### Before Committing
- [ ] Run tests: `bundle exec rspec`
- [ ] Run linter: `bin/rubocop`
- [ ] Run security scan: `bin/brakeman --no-pager`
- [ ] Verify changes work in the browser (for UI changes)
- [ ] Update tests if needed
- [ ] Update documentation if needed

### Pull Request Guidelines
- Write clear commit messages in present tense
- Reference issue numbers when applicable
- Ensure CI passes (all three jobs: security, lint, test)
- Keep PRs focused and reasonably sized
- Add screenshots for UI changes

## Special Notes

### Japanese Language Context
- Care recipients are called "clients" (利用者) not "patients"
- Care workers are "users" in the system (従業員/ヘルパー)
- Use respectful, simple Japanese in UI text
- Avoid technical jargon - remember the target users are elderly managers

### Business Domain
- **訪問介護** (visiting care): Care workers visit clients' homes
- Shifts involve visiting specific clients at specific times
- Scheduling conflicts must be prevented (same user, overlapping times)
- Care levels (medical_care) determine which workers can serve which clients
- Teams may share clients across department boundaries

### Performance Considerations
- Use database indexes for frequently queried columns
- Avoid N+1 queries - use `includes`, `joins` appropriately
- Cache expensive computations when appropriate
- Keep Turbo updates targeted to minimize DOM changes

## Resources

- [Rails Guides](https://guides.rubyonrails.org/)
- [Hotwire Documentation](https://hotwired.dev/)
- [RSpec Documentation](https://rspec.info/)
- [Devise Documentation](https://github.com/heartcombo/devise)
- [Pundit Documentation](https://github.com/varvet/pundit)
