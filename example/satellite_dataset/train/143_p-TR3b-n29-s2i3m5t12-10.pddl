(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	spectrograph1 - mode
	thermograph4 - mode
	spectrograph0 - mode
	spectrograph2 - mode
	infrared3 - mode
	Star1 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	GroundStation5 - direction
	Star8 - direction
	GroundStation9 - direction
	Star10 - direction
	Star11 - direction
	Star7 - direction
	Star6 - direction
	Star0 - direction
	GroundStation2 - direction
	Planet12 - direction
	Planet13 - direction
	Planet14 - direction
	Planet15 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 infrared3)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 Star11)
	(supports instrument1 spectrograph1)
	(supports instrument1 infrared3)
	(supports instrument1 spectrograph2)
	(calibration_target instrument1 Star0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star11)
	(supports instrument2 spectrograph1)
	(supports instrument2 thermograph4)
	(calibration_target instrument2 GroundStation2)
	(calibration_target instrument2 Star0)
	(calibration_target instrument2 Star6)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star10)
)
(:goal (and
	(pointing satellite1 Star10)
	(have_image Planet12 thermograph4)
	(have_image Planet13 spectrograph1)
	(have_image Planet14 spectrograph1)
	(have_image Planet15 spectrograph2)
))

)
