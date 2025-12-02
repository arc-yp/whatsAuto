@extends('layouts.app', ['title' => __tr('Addons')])
@section('content')
@include('users.partials.header', [
'title' => __tr('Addons'),
'description' =>'',
'class' => 'col-lg-7'
])
<div class="container-fluid ">
    <div class="row">
        <div class="col-xl-12 mb-3">
            <div class="float-right">
               
            </div>
        </div>
        <x-lw.modal id="lwInstallNewAddonDialog" :header="__tr('Update Existing Or Install New Addon')" :hasForm="true"
        data-pre-callback="appFuncs.clearContainer">
        <x-lw.form id="lwInstallNewAddonDialogForm" :action="route('central.addons.write.install')"
            :data-callback-params="['modalId' => '#lwInstallNewAddonDialog', 'datatableId' => '#lwContactList']"
            data-callback="appFuncs.modelSuccessCallback">
            <div class="lw-form-modal-body">
                <div class="alert alert-danger">
                    {{ __tr('You need to select zip file under your downloaded main zip file package file.') }}
                </div>
                <div class="form-group ">
                    <input id="lwInstallAddonDocumentFilepond" type="file" data-allow-revert="true"
                        data-label-idle="{!! __tr('Select & Upload Addon ZIP file') !!}" class="lw-file-uploader"
                        data-instant-upload="true"
                        data-action="<?= route('central.addons.write.upload', 'addon_upload_file') ?>"
                        data-file-input-element="#lwInstallAddonDocument" data-allowed-media='{{ getMediaRestriction('
                        addon_upload_file') }}'>
                    <input id="lwInstallAddonDocument" type="hidden" value="" name="document_name" />
                </div>
            </div>
            <!-- form footer -->
            <div class="modal-footer">
                <!-- Submit Button -->
                <button type="submit" class="btn btn-primary">{{ __tr('Install') }}</button>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">{{ __tr('Close') }}</button>
            </div>
        </x-lw.form>
    </x-lw.modal>
        <!-- button -->
        <div class="col">
         
                </div>
            </div>
        </div>
    </div>
</div>
@endsection()