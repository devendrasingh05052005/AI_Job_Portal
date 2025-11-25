from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import CustomUser, Job, Application, JobField


class CustomUserAdmin(UserAdmin):
    model = CustomUser
    list_display = ['username', 'email', 'is_staff', 'is_candidate', 'is_recruiter']
    list_filter = ['is_candidate', 'is_recruiter']

    fieldsets = UserAdmin.fieldsets + (
        (None, {'fields': ('is_candidate', 'is_recruiter')}),
    )
    add_fieldsets = UserAdmin.add_fieldsets + (
        (None, {'fields': ('is_candidate', 'is_recruiter')}),
    )

admin.site.register(CustomUser, CustomUserAdmin)

# Baaki models ko register karein
admin.site.register(Job)
admin.site.register(Application)
admin.site.register(JobField)